within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function singleUTubeResistances
  "Thermal resistances for single U-tube, according to Bauer et al. (2011)"

  // Geometry of the borehole
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  // Geometry of the pipe
  input Modelica.SIunits.Radius rTub "Radius of the tube";
  input Modelica.SIunits.Length eTub "Thickness of the tubes";
  input Modelica.SIunits.Length sha
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties
  input Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the grout";
  input Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soi";
  input Modelica.SIunits.ThermalConductivity kTub
    "Thermal conductivity of the tube";

  // Inputs for convection
  input Modelica.SIunits.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.SIunits.DynamicViscosity mueMed
    "Dynamic viscosity of the fluid";
  input Modelica.SIunits.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.SIunits.MassFlowRate m1_flow "Mass flow rate";
  input Modelica.SIunits.MassFlowRate m1_flow_nominal "Nominal mass flow rate";
  input Modelica.SIunits.MassFlowRate m2_flow "Mass flow rate";
  input Modelica.SIunits.MassFlowRate m2_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Modelica.SIunits.ThermalResistance Rgb
    "Thermal resistance between grout zone and borehole wall";
  output Modelica.SIunits.ThermalResistance Rgg
    "Thermal resistance between the two grout zones";
  output Modelica.SIunits.ThermalResistance RCondGro
    "Thermal resistance between: pipe wall to capacity in grout";
  output Real x "Capacity location";

protected
  Boolean test=false "thermodynamic test for R and x value";

  Modelica.SIunits.ThermalResistance Rg
    "Thermal resistance between outer borehole wall and one tube";
  Modelica.SIunits.ThermalResistance Rar
    "Thermal resistance between the two pipe outer walls";
  Modelica.SIunits.ThermalResistance RCondPipe
    "Thermal resistance of the pipe wall";

  Real Rb
    "Fluid-to-grout resistance, as defined by Hellstroem. Resistance from the fluid in the pipe to the borehole wall";
  Real Ra
    "Grout-to-grout resistance (2D) as defined by Hellstroem. Interaction between the different grout part";

  Modelica.SIunits.ThermalResistance RConv1
    "Convection resistance (or conduction in fluid if no mass flow)";
  Modelica.SIunits.ThermalResistance RConv2
    "Convection resistance (or conduction in fluid if no mass flow)";

  // Help variables
  Real sigma "Help variable as defined by Hellstroem";
  Real beta "Help variable as defined by Hellstroem";
  Real R_1delta_LS
    "One leg of the triangle resistance network, corresponding to the line source solution";
  Real R_1delta_MP
    "One leg of the triangle resistance network, corresponding to the multipole solution";
  Real Ra_LS
    "Grout-to-grout resistance calculated with the line-source approximation";

  Integer i=1 "Loop counter";

algorithm
  // Convection resistances
  RConv1 :=convectionResistance(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m1_flow,
    m_flow_nominal=m1_flow_nominal);

  RConv2 :=convectionResistance(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m2_flow,
    m_flow_nominal=m2_flow_nominal);

  // ********** Rb and Ra from multipole **********
  // Help variables
  RCondPipe :=Modelica.Math.log((rTub + eTub)/rTub)/(2*Modelica.Constants.pi*hSeg*kTub);
  sigma :=(kFil - kSoi)/(kFil + kSoi);
  R_1delta_LS :=1/(2*Modelica.Constants.pi*kFil)*(log(rBor/(rTub + eTub)) + log(rBor/(2*sha)) +
    sigma*log(rBor^4/(rBor^4 - sha^4))) + RCondPipe*hSeg;
  R_1delta_MP :=R_1delta_LS - 1/(2*Modelica.Constants.pi*kFil)*((rTub + eTub)^2/
    (4*sha^2)*(1 - sigma*4*sha^4/(rBor^4 - sha^4))^2)/((1 + beta)/(1 - beta) + (
    rTub + eTub)^2/(4*sha^2)*(1 + sigma*16*sha^4*rBor^4/(rBor^4 - sha^4)^2));
  Ra_LS      :=1/(Modelica.Constants.pi*kFil)*(log(2*sha/rTub) + sigma*log((
    rBor^2 + sha^2)/(rBor^2 - sha^2))) + 2*RCondPipe*hSeg;

  //Rb and Ra
  Rb :=R_1delta_MP/2;
  Ra :=Ra_LS - 1/(Modelica.Constants.pi*kFil)*(rTub^2/(4*sha^2)*(1 + sigma*
    4*rBor^4*sha^2/(rBor^4 - sha^4))/((1 + beta)/(1 - beta) - rTub^2/(4*sha^2) +
    sigma*2*rTub^2*rBor^2*(rBor^4 + sha^4)/(rBor^4 - sha^4)^2));

  //Conversion of Rb (resp. Ra) to Rg (resp. Rar) of Bauer:
  Rg  :=2*Rb/hSeg - RConv1 - RCondPipe;
  Rar :=Ra/hSeg - 2*(RConv1 + RCondPipe);

/* **************** Simplification of Bauer for single U-tube ************************
  //Thermal resistance between: Outer wall and one tube
     Rg := Modelica.Math.acosh((rBor^2 + (rTub + eTub)^2 - sha^2)/(2*rBor*(rTub +
       eTub)))/(2*Modelica.Constants.pi*hSeg*kFil)*(1.601 - 0.888*sha/rBor);

  //Thermal resistance between: The two pipe outer walls
  Rar := Modelica.Math.acosh((2*sha^2 - (rTub + eTub)^2)/(rTub + eTub)^2)/(2*
       Modelica.Constants.pi*hSeg*kFil);
*************************************************************************************** */

  // ********** Resistances and capacity location according to Bauer **********

  // fixme: This loop needs to be changed for the following reason:
  //        The test "    test := ((1/Rgg + 1/2/Rgb)^(-1) > 0);" depends on the
  //        mass flow rates m1_flow and m2_flow. Therefore, this function is
  //        discontinuous in the mass flow rate.
  //        To fix this, we could call this function to build a table for the outputs,
  //        and then interpolate in the table using cubic splines.
  while test == false and i <= 10 loop
    // Capacity location (with correction factor in case that the test is negative)
    x := Modelica.Math.log(sqrt(rBor^2 + 2*(rTub + eTub)^2)/(2*(rTub + eTub)))/
      Modelica.Math.log(rBor/(sqrt(2)*(rTub + eTub)))*((15 - i + 1)/15);

    //Thermal resistance between the grout zone and bore hole wall
    Rgb := (1 - x)*Rg;

    //Thermal resistance between the two grout zones
    Rgg := 2*Rgb*(Rar - 2*x*Rg)/(2*Rgb - Rar + 2*x*Rg);

    // Thermodynamic test to check if negative R values make sense. If not, decrease x-value.
    // fixme: the implemented is only for single U-tube BHE's.
    test := ((1/Rgg + 1/2/Rgb)^(-1) > 0);
    i := i + 1;
  end while;
  //Conduction resistance in grout from pipe wall to capacity in grout
  RCondGro := x*Rg + Modelica.Math.log((rTub + eTub)/rTub)/(2*Modelica.Constants.pi
    *hSeg*kTub);

  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the different thermal resistances present in a single-U-tube borehole 
using the method of Bauer et al. [1].
It also computes the fluid-to-ground thermal resistance <i>R<sub>b</sub></i> 
and the grout-to-grout thermal resistance <i>R<sub>a</sub></i> 
as defined by Hellstroem [2] using the multipole method.
</p>
<p>
The figure below shows the thermal network set up by Bauer et al.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://fixme/Boreholes/BaseClasses/Documentation/Bauer_singleUTube_small.png\"/>
</p>
<p>
The different resistances are calculated with following equations:</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://fixme/Images/Documentation/Bauer_resistanceValues.PNG\"/>
</p>
<p>
Notice that each resistance each resistance still needs to be divided by 
the height of the borehole segment <i>h<sub>Seg</sub></i>.
</p>
<p>
The fluid-to-ground thermal resistance <i>R<sub>b</sub></i> and the grout-to-grout resistance <i>R<sub>a</sub></i> 
are calculated with the multipole method (Hellstroem (1991)) shown below.
</p>
<p>
<!-- If this is an equation, it needs to be typed, not an image -->
<img alt=\"image\" src=\"modelica://fixme/Images/Documentation/Rb_multipole.png\"/>
</p>
<p>
<!-- If this is an equation, it needs to be typed, not an image -->
<img alt=\"image\" src=\"modelica://fixme/Images/Documentation/Ra_multipole.png\"/>
</p>
<p>
where 
<!-- fixme: use greek symbols such as &lambda; -->
<i>lambda<sub>b</sub></i> and <i>lambda</i>are the conductivity of the filling material 
and of the ground respectively, 
<i>r<sub>p</sub></i> and <i>r<sub>b</sub></i> 
are the pipe and the borehole radius, 
<i>D</i> is the shank spacing (center of borehole to center of pipe), 
<i>R<sub>p</sub></i> is resistance from the fluid to the outside wall of the pipe, 
<i>r<sub>c</sub></i> is the radius at which the ground temperature is radially uniform and 
<i>Epsilon</i> can be neglected as it is close to zero.
</p>
<h4>References</h4>
<p>G. Hellstr&ouml;m. 
<i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. 
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. 
<i>Thermal resistance and capacity models for borehole heat exchangers</i>. 
International Journal Of Energy Research, 35:312&ndash;320, 2010.</p>
</html>", revisions="<html>
<p>
<ul>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul></p>
</html>"));
end singleUTubeResistances;
