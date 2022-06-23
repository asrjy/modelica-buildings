within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Diversion "Diversion circuit"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=dp2_nominal,
    final m1_flow_nominal=m2_flow_nominal,
    final dpBal2_nominal=0,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None);

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
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then {dp2_nominal, dpBal3_nominal} else
      {0, 0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(port_a2, val.port_1)
    annotation (Line(points={{60,100},{60,10}}, color={0,127,255}));
  connect(val.port_2,res1. port_a)
    annotation (Line(points={{60,-10},{60,-40}}, color={0,127,255}));
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-60},{60,-100}}, color={0,127,255}));
  connect(jun.port_1, port_a1) annotation (Line(points={{-60,-10},{-60,-100},{-60,
          -100}}, color={0,127,255}));
  connect(jun.port_2, port_b2)
    annotation (Line(points={{-60,10},{-60,100}}, color={0,127,255}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,20},{80,20},
          {80,0},{72,0}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{67,-6},{67,-40},{120,-40}}, color={0,0,127}));
  connect(jun.port_3, res3.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(res3.port_b, val.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",                                                                                                                                                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic below) is used for constant flow 
primary circuits and variable flow consumer circuits where the 
consumer circuit has the same supply temperature set point as the 
primary circuit.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Diversion.png\"/>
</p>
<p>
The following table presents the main characteristics of this configuration.
</p>
<table class=\"releaseTable\" summary=\"Main characteristics\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td valign=\"top\">
Primary circuit
</td>
<td valign=\"top\">
Constant flow
</td>
</tr>
<tr>
<td valign=\"top\">
Secondary (consumer) circuit
</td>
<td valign=\"top\">
Variable flow
</td>
</tr>
<tr>
<td valign=\"top\">
Typical applications
</td>
<td valign=\"top\">
Single heating or cooling coil served by a constant flow circuit
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">

</td>
</tr>
<tr>
<td valign=\"top\">
Built-in valve control options
</td>
<td valign=\"top\">
No built-in controls
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve selection
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-AB</sub>(y=100%) / 
&Delta;p<sub>J-AB</sub>(y=0%) =
&Delta;p<sub>A-AB</sub>(y=100%) / 
(&Delta;p<sub>b2-a2</sub>(y=100%) + &Delta;p<sub>A-AB</sub>(y=100%)) =
&Delta;p<sub>A-AB</sub>(y=100%) / 
(&Delta;p<sub>a1-b1</sub>(y=100%) - &Delta;p<sub>AB-b1</sub>(y=100%))</i><br/>
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
No primary balancing valve needed in addition to the self-acting 
&Delta;P control valve.<br/>
(For an actuated control valve with external controls,
the same balancing requirements as for 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
apply for a primary design flow rate <i>5</i> to <i>10%</i> 
higher than <code>m2_flow_nominal</code>.)
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistances include<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Direct branch: control valve direct branch <code>val.res1</code> 
and whole consumer circuit between <code>b2</code> and <code>a2</code><br/>
Bypass branch: control valve bypass branch <code>val.res3</code> 
and bypass balancing valve <code>res3</code>
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
Lumped flow resistance includes consumer circuit
and control valve only.
Primary balancing valve always modeled as a distinct
flow resistance.
</p>
<p>
The secondary balancing valve pressure drop
<code>dpBal2_nominal</code>
stands for the pressure drop of the balancing valve
in the bypass.
</p>
</html>"),
    Icon(graphics={
        Line(
          points={{-60,-90},{-60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-90},{60,90}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={60,-10},
          rotation=90,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{10,10},{0,-10},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={60,10},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={50,0},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,10},{94,-10}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={60,0},
          rotation=180),
        Line(
          points={{2.29846e-15,-10},{0,90}},
          color={0,0,0},
          thickness=0.5,
          origin={30,0},
          rotation=90),
        Polygon(
          points={{-54,-60},{-60,-50},{-66,-60},{-54,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=90,
          origin={-10,-40}),
        Polygon(
          points={{54,-26},{60,-36},{66,-26},{54,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-54,46},{-60,56},{-66,46},{-54,46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{66,54},{60,44},{54,54},{66,54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-80,0},{-80,24},{84,24},{84,10}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={86,-100},
          rotation=270,
          visible=dpBal2_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={106,-90},
          rotation=360,
          visible=dpBal2_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={106,-90},
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
          visible=dpBal1_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=180,
          visible=dpBal3_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=180,
          origin={-10,14},
          visible=dpBal3_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=270,
          visible=dpBal3_nominal > 0)}));
end Diversion;
