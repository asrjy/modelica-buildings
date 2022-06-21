within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionTwoWay "Injection circuit with two-way valve"
  extends HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    set(final unit="K", displayUnit="degC"),
    final dpBal3_nominal=0,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay);

  FixedResistances.Junction junSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPum,
    final typMod=typPumMod,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=dp2_nominal + dpBal2_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,40})));
  Components.TwoWayValve val(
    redeclare final package Medium = Medium,
    final typCha=typCha,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then dpBal1_nominal else 0,
    final flowCharacteristics=flowCharacteristics)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,-40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit supply temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  FixedResistances.Junction junRet(
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
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
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
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-80})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit return temperature sensor"
                                                 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  Controls.PIDWithOperatingMode ctl(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    final reverseActing=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti) if typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Controller"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(final nin=2)
    "Select measured signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-60})));
  replaceable FixedResistances.LosslessPipe res3(
    redeclare final package Medium =Medium,
    final m_flow_nominal=m2_flow_nominal - m1_flow_nominal)
    "Fluid pass-through that can be replaced by check valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant ctlVar(
    final k=Integer(typVar))
    "Controlled variable selector"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

initial equation
  if m2_flow_nominal <= m1_flow_nominal then
    Modelica.Utilities.Streams.print(
      "*** Warning: In " + getInstanceName() +
      ": Primary mass flow rate should be strictly lower than consumer circuit mass flow rate " +
      "at design conditions to ensure an actual variable flow in the primary.");
  end if;

  if typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable and
    typVar==Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature then
    Modelica.Utilities.Streams.print(
      "*** Warning: In " + getInstanceName() +
      ": Return temperature control is likely not compatible with a variable flow consumer circuit.");
  end if;
equation
  connect(junSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(junSup.port_1, port_a1)
    annotation (Line(points={{-60,-10},{-60,-100}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(junRet.port_1,res2. port_b)
    annotation (Line(points={{60,10},{60,20}}, color={0,127,255}));
  connect(val.port_b,res1. port_a)
    annotation (Line(points={{60,-50},{60,-70}}, color={0,127,255}));
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-90},{60,-100}}, color={0,127,255}));
  connect(res2.port_a, T2Ret.port_b)
    annotation (Line(points={{60,40},{60,50}}, color={0,127,255}));
  connect(T2Ret.port_a, port_a2)
    annotation (Line(points={{60,70},{60,100}}, color={0,127,255}));
  connect(ctl.y, val.y)
    annotation (Line(points={{32,-40},{48,-40}}, color={0,0,127}));
  connect(set, ctl.u_s)
    annotation (Line(points={{-120,-40},{8,-40}},  color={0,0,127}));
  connect(mode, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(T2Sup.T, extIndSig.u[1]) annotation (Line(points={{-49,60},{-40,60},{-40,
          -48},{-40.5,-48}},         color={0,0,127}));
  connect(T2Ret.T, extIndSig.u[2]) annotation (Line(points={{49,60},{-39.5,60},{
          -39.5,-48}},     color={0,0,127}));
  connect(junRet.port_2, val.port_a)
    annotation (Line(points={{60,-10},{60,-30}}, color={0,127,255}));
  connect(extIndSig.y, ctl.u_m)
    annotation (Line(points={{-40,-72},{-40,-80},{20,-80},{20,-52}},
                                                          color={0,0,127}));
  connect(mode, ctl.mod) annotation (Line(points={{-120,80},{-20,80},{-20,-60},
          {14,-60},{14,-52}}, color={255,127,0}));
  connect(junRet.port_3, res3.port_a)
    annotation (Line(points={{50,0},{10,0}}, color={0,127,255}));
  connect(res3.port_b, junSup.port_3)
    annotation (Line(points={{-10,0},{-50,0}}, color={0,127,255}));
  connect(ctlVar.y, extIndSig.index)
    annotation (Line(points={{-68,-60},{-52,-60}}, color={255,127,0}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-20},{40,
          -20},{40,-40},{48,-40}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-69,52},{-69,54},{80,54},{80,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-67,52},{80,52},
          {80,40},{120,40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{53,-46},{53,-60},{80,-60},{80,-40},{120,-40}},
                                                           color={0,0,127}));
  connect(isEna.y, pum.y1) annotation (Line(points={{12,80},{20,80},{20,20},{
          -67,20},{-67,34.8}}, color={255,0,255}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,-90},{-60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-90},{60,90}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-54,-60},{-60,-50},{-66,-60},{-54,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,-26},{60,-36},{66,-26},{54,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{-40,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-60,80},{-42.5,50},{-77.5,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=typPum <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
        Line(
          points={{3.5231e-15,-30},{0,90}},
          color={0,0,0},
          thickness=0.5,
          origin={30,30},
          rotation=90),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={-30,70}),
        Rectangle(
          extent={{26,10},{46,-10}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,0},
          rotation=180),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,0},
          rotation=90),
        Line(
          points={{26,0},{-100,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={60,60},
          rotation=360,
          visible=dpBal2_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={40,50},
          rotation=270,
          visible=dpBal2_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={60,60},
          visible=dpBal2_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-60},
          rotation=180,
          visible=dpBal1_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-60},
          rotation=90,
          visible=dpBal1_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-70},
          rotation=270,
          visible=dpBal1_nominal > 0)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The following table presents the main characteristics of this configuration.<br/>
</p>
<table summary = \"Main characteristics\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\">
<tr>
<td><p>Primary circuit</p></td>
<td><p>Variable flow
(See caveats in examples.)
</p></td>
</tr>
<tr>
<td><p>Secondary (consumer) circuit</p></td>
<td><p>Constant or variable flow</p></td>
</tr>
<tr>
<td><p>Typical applications</p></td>
<td><p>...</p></td>
</tr>
<tr>
<td><p>Built-in control options</p></td>
<td><p>
Supply temperature (must be different from primary)</p>
<p>
Return temperature (incompatible with variable secondary)
</p></td>
</tr>
<tr>
<td><p>Control valve authority
(See the nomenclature in the icon layer.)
</p></td>
<td><p>
<i>&beta; = &Delta;p<sub>A-B</sub> / &Delta;p<sub>a1-b1</sub></i><br/>
(Does not depend on the primary balancing valve.)
</p></td>
</tr>
<tr>
<td><p>Balancing requirement</p></td>
<td><p>
...
</p></td>
</tr>
</table>

<p>
Lumped flow resistance includes primary balancing valve
and control valve only.

</p>
</html>"));
end InjectionTwoWay;
