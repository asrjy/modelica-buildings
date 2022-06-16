within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model DualMixing "Dual mixing circuit"
  extends HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=3e3,
    dpBal3_nominal=dpValve_nominal,
    set(final unit="K", displayUnit="degC"),
    final dpBal1_nominal=0,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final have_pum=true,
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature);

  Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={0,0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      choicesAllMatching = true,
      Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-40})));
  FixedResistances.Junction jun(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-40})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Secondary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
  Buildings.Fluid.HydronicConfigurations.Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPumMod,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=dp2_nominal + dpBal2_nominal + dpBal3_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      choicesAllMatching = true,
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
      else 1)
    "Consumer circuit supply temperature sensor"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=(m2_flow_nominal - m1_flow_nominal) .* {1,-1,1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  FixedResistances.Junction junBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=(m2_flow_nominal - m1_flow_nominal) .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit return temperature sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant One(final k=1)
    if typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant
    "one"
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch on/off"
    annotation (Placement(transformation(extent={{0,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Controls.PIDWithOperatingMode ctl(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    final reverseActing=typFun == Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti) if have_ctl
    "Controller"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal - m1_flow_nominal,
    final dp_nominal=dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0)));

initial equation
  assert(
    m2_flow_nominal > m1_flow_nominal,
    "In " + getInstanceName() +
    ": Primary mass flow rate must be strictly lower than consumer circuit mass flow rate " +
    "at design conditions.");

  if dpBal3_nominal <= dpValve_nominal then
    Modelica.Utilities.Streams.print(
      "*** Warning: In " + getInstanceName() +
      ": The bypass balancing valve should generate a pressure drop higher than " +
      "the control valve at design conditions to provide sufficient primary flow.");
  end if;

equation
  connect(val.port_3, jun.port_3)
    annotation (Line(points={{-50,-40},{50,-40}}, color={0,127,255}));
  connect(jun.port_2, port_b1)
    annotation (Line(points={{60,-50},{60,-100}}, color={0,127,255}));
  connect(val.port_1, port_a1)
    annotation (Line(points={{-60,-50},{-60,-100}}, color={0,127,255}));
  connect(junBypRet.port_2, jun.port_1)
    annotation (Line(points={{60,-10},{60,-30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(pum.port_a, junBypSup.port_2)
    annotation (Line(points={{-60,30},{-60,10}}, color={0,127,255}));
  connect(val.port_2, junBypSup.port_1)
    annotation (Line(points={{-60,-30},{-60,-10}}, color={0,127,255}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b, res2.port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(res2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(mod, isEna.u)
    annotation (Line(points={{-120,80},{-42,80}}, color={255,127,0}));
  connect(isEna.y, swi.u2) annotation (Line(points={{-18,80},{16,80},{16,30},{2,
          30}}, color={255,0,255}));
  connect(yPum, swi.u1) annotation (Line(points={{-120,40},{-80,40},{-80,56},{
          10,56},{10,38},{2,38}},
                                color={0,0,127}));
  connect(One.y, swi.u1) annotation (Line(points={{28,80},{20,80},{20,38},{2,38}},
        color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{18,20},{10,20},{10,22},{2,22}},
                                               color={0,0,127}));
  connect(swi.y, pum.y)
    annotation (Line(points={{-22,30},{-30,30},{-30,40},{-48,40}},
                                                 color={0,0,127}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-86,-40},{-86,-60},
          {-12,-60}}, color={0,0,127}));
  connect(T2Sup.T, ctl.u_m) annotation (Line(points={{-49,60},{-40,60},{-40,-80},
          {0,-80},{0,-72}}, color={0,0,127}));
  connect(ctl.y, val.y) annotation (Line(points={{12,-60},{20,-60},{20,-20},{
          -80,-20},{-80,-40},{-72,-40}}, color={0,0,127}));
  connect(mod, ctl.mod) annotation (Line(points={{-120,80},{-90,80},{-90,-76},{
          -6,-76},{-6,-72}}, color={255,127,0}));
  connect(junBypSup.port_3, res3.port_b)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(res3.port_a, junBypRet.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-40},{-72,
          -40}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-51,52},{-51,54},{90,54},{90,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-53,52},{90,52},
          {90,40},{120,40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{-67,-34},{-67,
          -26},{90,-26},{90,-60},{120,-60}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Icon(graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/DualMixing.svg")}),
    Documentation(info="<html>
<p>
This configuration is typically used instead of 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>
when the design supply temperature of the consumer circuit differs
from the primary circuit.
If the design temperatures are equal this configuration may theoritically
still be used although it loses its main advantage which is that the 
control valve can be sized for a lower flow rate 
<i>m&#775;<sub>1, design</sub></i> 
in the primary branch (see below) and can therefore be smaller.
The control valve should be sized with a pressure drop at least equal to the
maximum of <i>&Delta;p<sub>a1-b1</sub></i> and <i>3e3</i>&nbsp;Pa
at <i>m&#775;<sub>1, design</sub></i>.
Its authority is 
<i>&beta; = &Delta;p<sub>A-AB</sub> / 
(&Delta;p<sub>A-AB</sub> + &Delta;p<sub>a1-b1</sub>)</i>.
</p>
<p>
The balancing procedure should ensure that the three-way valve is fully
open at design conditions. This gives the following relationship
between the primary and secondary mass flow rate, involving the secondary
supply and return temperature and the primary supply temperature.
</p>
<p>
<i>
m&#775;<sub>1, design</sub> = m&#775;<sub>2, design</sub> *
(T<sub>2, sup, design</sub> - T<sub>2, ret, design</sub>) / 
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i>
</p>
<p>
The flow rate in the fixed bypass is then given by the following equation.
</p>
<p>
<i>
m&#775;<sub>3, design</sub> = 
m&#775;<sub>2, design</sub> - m&#775;<sub>1, design</sub> =
m&#775;<sub>2, design</sub> *
(T<sub>1, sup, design</sub> - T<sub>2, sup, design</sub>) / 
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i>
</p>
<p>
The model is not configured to support a primary flow rate
equal to the secondary flow rate at design conditions and an
error is triggered. This corresponds to the odd use case where
the primary and secondary design temperatures are equal (see above).
</p>
<p>
The bypass balancing valve works <i>together</i> with
the secondary pump to generate the pressure differential differential at the 
boundaries of the control valve.
So it is paramount for proper operation of the consumer circuit that the 
bypass balancing valve generates enough pressure drop at its design flow rate
<i>m&#775;<sub>3, design</sub></i> otherwise the consumer circuit is starved 
with primary flow rate despite the control valve being fully open.
So oversizing the bypass balancing valve (yielding a lower pressure drop) 
is detrimental to the consumer circuit operation.
Undersizing the bypass balancing valve (yielding a lower pressure drop) 
does not disturb the secondary circuit operation as the control valve
then compensates for the elevated pressure differential by 
working at a lower opening in average. 
However, the secondary pump head is increased and so is the electricity
consumption.
See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.DualMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.DualMixing</a>
for a numerical illustration of those effects.
</p>
<p>
By default the secondary pump is parameterized with <code>m2_flow_nominal</code> 
and <code>dp2_nominal + dpBal2_nominal + dpBal3_nominal</code> at maximum speed.
</p>
</html>"));
end DualMixing;