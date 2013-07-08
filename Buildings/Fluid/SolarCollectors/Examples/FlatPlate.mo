within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlate "Test model for FlatPlate"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";

  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    nSeg=3,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FPGuangdongFSPTY95
        (),
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    nPanels=1) "Flat plate solar collector model"
             annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="bar") = 100000) "Outlet for water flow"
                                      annotation (Placement(transformation(extent={{80,-20},
            {60,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{32,-20},{52,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
        Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-32,-20},{-12,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa")) "Inlet for water flow"                                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-10})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=3/86400,
    offset=100000,
    amplitude=-solCol.dp_nominal)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{20,-10},{32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{52,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-12,-10},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-40,-10},{-32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-12,30},{-6,30},{-6,-0.4},{0,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, sou.p_in) annotation (Line(
      points={{-79,-10},{-72,-10},{-72,-18},{-62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This example demonstrates the implementation of 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> 
Buildings.Fluid.SolarCollectors.FlatPlate</a>. 
In it water is passed through a solar collector while being heated by the 
sun in the San Francisco, CA, USA climate.
</p>
</html>",revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlate.mos"
        "Simulate and Plot"),
    Icon(graphics));
end FlatPlate;
