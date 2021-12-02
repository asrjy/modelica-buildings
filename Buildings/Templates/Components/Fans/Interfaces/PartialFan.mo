within Buildings.Templates.Components.Fans.Interfaces;
partial model PartialFan
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Buildings.Templates.Components.Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senFlo
    "Set to true for air flow measurement"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Types.FanSingle typSin=
    Buildings.Templates.Components.Types.FanSingle.Housed
    "Type of single fan"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition"));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Fan.None
    "Control bus"
    annotation (Placement(
      visible=false,
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_senFlo,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{90,10}})));
equation
  /* Control point connection - start */
  connect(V_flow.y, bus.V_flow);
  /* Control point connection - stop */
  connect(port_b, V_flow.port_b)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Array.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Housed,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Housed.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Plug,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Plug.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Propeller,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg"),
    Bitmap(
      visible=have_senFlo and typ<>Buildings.Templates.Components.Types.Fan.None,
        extent=if text_flip then {{-140,-240},{-220,-160}} else {{-220,-240},{-140,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
    Line(
      visible=have_senFlo and typ<>Buildings.Templates.Components.Types.Fan.None,
          points={{-180,-160},{-180,0},{-100,0}},
          color={0,0,0},
          thickness=1),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent=if text_flip then {{80,-360},{-80,-160}} else {{-80,-360},{80,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/VFD.svg"),
    Line(
      visible=typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.MultipleVariable,
          points={{0,-100},{0,-160}},
          color={0,0,0},
          thickness=1),
    Line(
      visible=have_senFlo and typ==Buildings.Templates.Components.Types.Fan.MultipleVariable,
          points={{-100,0},{0,0}},
          color={0,0,0},
          thickness=1)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFan;
