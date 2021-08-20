''' Python module that is used for the example
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Validation.ResponsePython
'''
import os
import shutil

def doStep(dblInp, state):
    modelicaWorkingPath = os.getcwd()
    py_dir = os.path.join(modelicaWorkingPath,'Resources/Python-Sources')

    # Temporary folder used primarily for store TOUGH simulation result "SAVE".
    # The "SAVE" file is needed for the next invocation for generating initial
    # conditions for TOUGH simulation.
    # This temporary folder should be created in advance before calling this 
    # python script.
    tou_tmp = os.path.join(py_dir, 'toughTemp')
    
    # Heat flux from borehole wall to ground: Modelica --> Tough
    Q = dblInp[:10]
    # Initial borehole wall temperature at the start of modelica simulation
    T_start = [dblInp[i] for i in range(10,20)]
    # Current outdoor temperature
    T_out = dblInp[-2]
    # Current time when needs to call TOUGH. This is also the end time of TOUGH simulation.
    tim = dblInp[-1]

    # Find the depth of each layer
    meshFile = os.path.join(py_dir, 'ToughFiles', 'MESH')
    toughLayers = find_layer_depth(meshFile)

    add_grid_boundary(toughLayers)

    # Find Modelica layers
    modelicaLayers = modelica_mesh()

    # This is the first call of this python module. There is no state yet.
    if state == None:
        # Empty the TOUGH temporary folder
        empty_folder(tou_tmp)
        # Copy files in the folder 'TougFiles', which includes the initial temperature of
        # simulation domain, template files for TOUGH simulation, and utility programs
        copy_files(os.path.join(py_dir, 'ToughFiles'), tou_tmp)
        # Initialize the state
        T_tough_start = mesh_to_mesh(toughLayers, modelicaLayers, T_start, 'T_Mo2To')
        state = {'tLast': tim, 'Q': Q, 'T_tough': T_tough_start}
        T_toModelica = T_start
        p_Int = ident_set(101343.01, 10)
        x_Int = ident_set(10.5, 10)
        T_Int = ident_set(15.06+273.15, 10)
        ToModelica = T_toModelica + p_Int + x_Int + T_Int
    else:
        # Use the python object
        tLast = state['tLast']
        # Find the TOUGH simulation step size
        dt = tim - tLast

        # JModelica invokes the model twice during an event, in which case
        # dt is zero, or close to zero.
        # We don't evaluate the equations as this can cause chattering and in some
        # cases JModelica does not converge during the event iteration.
        # This guard is fine because the component is sampled at discrete time steps.
        if dt > 1e-2:
            # Create a temporary working directory
            wor_dir = create_working_directory()
            # Copy files generated by previous call to working directory
            copy_files(tou_tmp, wor_dir)

            # Change current directory to working directory
            os.chdir(wor_dir)

            # T_toTough = mesh_to_mesh(toughLayer, modelicaLayers, state['T'], 'Mo2To')
            Q_toTough = mesh_to_mesh(toughLayers, modelicaLayers, state['Q'], 'Q_Mo2To')

            # Check if there is 'GENER'. If the file does not exist, it means this is 
            # the first call of TOUGH simulation. There is no 'SAVE' yet so cannot call
            # `writeincon` to generate input files for TOUGH simulation.
            if not os.path.exists('GENER'):
                # create initial 'GENER' file
                initialize_gener(toughLayers, Q_toTough, 'GENER')
                # update existing 'INFILE'
                update_infile(tLast, tim, 'INFILE', 'newINFILE')

            # It's not the first call of TOUGH simulation. So there is 'SAVE' file from
            # previous TOUGH call and we can use `writeincon` to generate TOUGH input
            # files.
            else:
                # Delete old TOUGH input files
                if os.path.exists('GENER'):
                    os.remove('GENER')
                if os.path.exists('INCON'):
                    os.remove('INCON')
                if os.path.exists('newINFILE'):
                    os.remove('newINFILE')

                # Update `writeincon.inp` file. The `Q` is the measured heat flow from
                # each borehole segment to ground, from Modeica in previous call.
                # The `T_tough` is the wall temperature of each borehole segment from
                # last TOUGH simulation
                update_writeincon('writeincon.inp', tLast, tim, state['T_tough'], Q_toTough, T_out)

                # Generate TOUGH input files
                os.system("./writeincon < writeincon.inp")
                if os.path.exists('INFILE'):
                    os.remove('INFILE')
                os.rename('newINFILE', 'INFILE')

            # Conduct one step TOUGH simulation
            os.system("/opt/esd-tough/tough3-serial/tough3-install/bin/tough3-eos3")

            # Extract borehole wall temperature
            os.system("./readsave < readsave.inp > out.txt")
            data = extract_data('out.txt')
            T_tough = data['T_Bor']
            # Output to Modelica simulation
            T_toModelica = mesh_to_mesh(toughLayers, modelicaLayers, T_tough, 'To2Mo')

            # Outputs to Modelica
            ToModelica = T_toModelica + data['p_Int'] + data['x_Int'] + data['T_Int']

            # Update state
            state = {'tLast': tim, 'Q': Q, 'T_tough': T_tough}

            # Empty the 'toughTemp' folder
            empty_folder(tou_tmp)
            
            # Save files from temp directory to temp tough folder
            copy_files(wor_dir, tou_tmp)

            # Change back to original working directory
            os.chdir(modelicaWorkingPath)

            # Delete temporary working folder
            shutil.rmtree(wor_dir)

    return [ToModelica, state]

''' Create set of size num with identical value
'''
def ident_set(value, num):
    results = []
    for i in range(0, num):
        results.append(value)
    return results

''' Empty a folder
'''
def empty_folder(folder):
    # empty the 'toughTemp' folder
    touTmpFil = os.listdir(folder)
    for f in touTmpFil:
        os.remove(os.path.join(folder, f))

''' Create working directory
'''
def create_working_directory():
    import tempfile
    import getpass
    worDir = tempfile.mkdtemp(prefix='tmp-tough-modelica-' + getpass.getuser())
    return worDir

''' Copy files from source directory to destination directory
'''
def copy_files(src, dest):
    srcFiles = os.listdir(src)
    for fil in srcFiles:
        fileName = os.path.join(src, fil)
        if os.path.isfile(fileName):
            shutil.copy(fileName, dest)

''' Create initial `GENER` file for the 1st call of TOUGH
'''
def initialize_gener(toughLayesr, Q, fileName):
    with open(fileName, 'w') as f:
        f.write("GENER" + os.linesep)
        for i in range(0, len(Q)):
            f.write("%s  1sou 1" % toughLayesr[i]['layer'] + "                         HEAT %10.3e" % Q[i] + os.linesep)
        f.write("+++" + os.linesep)
        f.write("         1         2         3         4         5         6         7         8" + os.linesep)
        f.write("         9        10        11        12        13        14        15        16" + os.linesep)
        f.write("        17        18        19        20        21        22        23        24" + os.linesep)
        f.write("        25        26        27        28        29        30        31" + os.linesep)

''' Update the `INFILE` file for the first TOUGH call
'''
def update_infile(preTim, curTim, infile, outfile):
    fin = open(infile)
    fout = open(outfile, 'wt')
    count = 0
    for line in fin:
        count += 1
        if count == 31:
            endStr=line[20:]
            staStr='%10.1f%10.1f' % (preTim, curTim)
            fout.write(staStr + endStr)
        else:
            fout.write(line)
    fin.close()
    fout.close()
    os.remove(infile)
    os.rename(outfile, infile)

''' Find Tough mesh layer depth
'''
def find_layer_depth(fileName):
    fin = open(fileName)
    count = 0
    layers = list()
    dz = []
    z = []
    dz.append(1)
    z.append(-1.5)
    layers.append(
        {'layer': 'A4m',
         'z': z[0],
         'dz': dz[0]
        }
    )
    layInd = 0
    for line in fin:
        count += 1
        if count >=3 and count <= 32:
            layInd += 1
            strSet = line.split()
            z.append((-1)*float(strSet[-1].split('-')[-1]))
            thickness = 2*((z[layInd-1] - dz[layInd-1]/2) - z[layInd])
            dz.append(thickness)
            layers.append(
                {'layer': strSet[0],
                 'z': z[layInd],
                 'dz': thickness}
            )
    return layers

''' Find Modelica mesh size
''' 
def modelica_mesh():
    modelicaMeshSize = []
    for i in range(0,110,10):
        modelicaMeshSize.append(i)
    return modelicaMeshSize

''' Add upper and lower grid boundary
'''
def add_grid_boundary(layers):
    upperBound = 0
    lowerBound = (-1)*layers[0]['dz']
    layers[0]['upperBound'] = upperBound
    layers[0]['lowerBound'] = lowerBound
    for i in range(1,len(layers)):
        upperBound = lowerBound
        lowerBound = upperBound - layers[i]['dz']
        layers[i]['upperBound'] = upperBound
        layers[i]['lowerBound'] = lowerBound

''' From Modelica mesh to Tough mesh, distribute the values from Modelica elements to Tough elements
'''
def mesh_to_mesh(layers, modelicaLayers, variables, flag):
    values = []
    if (flag == 'T_Mo2To' or flag == 'Q_Mo2To'):
        for i in range(len(layers)):
            ub = (-1) * layers[i]['upperBound']
            lb = (-1) * layers[i]['lowerBound']
            dz = layers[i]['dz']
            scenario = 0
            for j in range(1, len(modelicaLayers)):
                cuMe = modelicaLayers[j]
                preMe = modelicaLayers[j-1]
                if ((ub >= preMe and ub < cuMe) and (lb > preMe and lb <= cuMe)):
                    scenario = 1
                    break
                elif (ub < cuMe and lb > cuMe and lb < modelicaLayers[-1]):
                    scenario = 2
                    break
                elif (ub < modelicaLayers[-1] and lb > modelicaLayers[-1]):
                    scenario = 3
                    break
                else:
                    continue
            if (scenario == 1):
                if (flag == 'Q_Mo2To'):
                    values.append(variables[j-1] * dz / (cuMe - preMe))
                else:
                    values.append(variables[j-1])
            elif (scenario == 3):
                if (flag == 'Q_Mo2To'):
                    values.append(variables[j-1] * (modelicaLayers[-1]-ub) / (cuMe - preMe))
                else:
                    values.append(variables[j-1])
            else:
                if (flag == 'Q_Mo2To'):
                    values.append(((cuMe - ub)*variables[j-1] + (lb-cuMe)*variables[j])/(cuMe - preMe))
                else:
                    values.append(((cuMe - ub)*variables[j-1] + (lb-cuMe)*variables[j])/(lb - up))
    else: 
        # (flag == 'To2Mo')
        for i in range(0, len(modelicaLayers)-1):
            cuMe = modelicaLayers[i]
            nexMe = modelicaLayers[i+1]
            accVar = 0
            for j in range(len(layers)):
                ub = (-1) * layers[j]['upperBound']
                lb = (-1) * layers[j]['lowerBound']
                # dz = layers[j]['dz']
                if ((ub >= cuMe and ub < nexMe) and (lb > cuMe and lb <= nexMe)):
                    ele = layers[j]['dz']
                elif ((ub >= cuMe and ub <nexMe) and (lb > cuMe and lb > nexMe)):
                    ele = nexMe - ub
                elif ((ub < cuMe and ub <= nexMe) and (lb > cuMe and lb <= nexMe)):
                    ele = lb - cuMe
                else:
                    continue
                accVar = accVar + ele * variables[j]
            values.append(accVar / (nexMe - cuMe))
    return values

''' Update the `writeincon.inp` file with the current time and state values that are
    seem as initial values of current TOUGH simulation
'''
def update_writeincon(infile, preTim, curTim, boreholeTem, heatFlux, T_out):
    fin = open(infile)
    fout = open('temp', 'wt')
    count = 0
    for line in fin:
        count += 1
        # assign initial time
        if count == 6:
            tempStr = '% 10.0f' % preTim
            fout.write(tempStr.strip() + os.linesep)
        # assign final time
        elif count ==  8:
            tempStr = '% 10.0f' % curTim
            fout.write(tempStr.strip() + os.linesep)
        # assign borehole wall temperature to each segment
        elif (count >= 10 and count <= 40):
            tempStr = '% 10.3f' % (boreholeTem[count-10] - 273.15)
            fout.write(tempStr.strip() + os.linesep)
        # assign heat flux to each segment
        elif (count >= 42 and count <= 72):
            tempStr = '% 10.3f' % heatFlux[count-44]
            fout.write(tempStr.strip() + os.linesep)
        elif (count == 74):
            tempStr = '% 10.3f' % (T_out - 273.15)
            fout.write(tempStr.strip() + os.linesep)
        else:
            fout.write(line)
    fin.close()
    fout.close()
    os.remove(infile)
    os.rename('temp', infile)

''' Extract the borehole temperature, and p, x and temperatures of interested points from TOUGH simulation results
'''
def extract_data(outFile):
    T_Bor = []
    T_Int = []
    p_Int = []
    x_Int = []
    fin = open(outFile)
    count = 0
    for line in fin:
        print (line)
        count += 1
        if count <= 31:
            T_Bor.append(float(line.strip())+273.15)
        if (count > 32 and count <= 42):
            temp = line.split()
            p_Int.append(float(temp[-3].strip()))
            x_Int.append(float(temp[-2].strip()))
            T_Int.append(float(temp[-1].strip())+273.15)
    data = {
        'T_Bor': T_Bor,
        'p_Int': p_Int,
        'x_Int': x_Int,
        'T_Int': T_Int
    }
    return data
