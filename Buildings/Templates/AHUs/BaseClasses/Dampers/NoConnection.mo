within Buildings.Templates.AHUs.BaseClasses.Dampers;
model NoConnection
  extends Templates.AHUs.Interfaces.Damper(
    final typ=Templates.AHUs.Types.Damper.NoConnection);

  Fluid.Sources.MassFlowSource_T floZer(
    redeclare final package Medium=Medium,
    final m_flow=0,
    final nPorts=1)
    "Zero flow boundary"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Fluid.Sources.MassFlowSource_T floZer1(
    redeclare final package Medium=Medium,
    final m_flow=0,
    final nPorts=1)
    "Zero flow boundary"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(floZer.ports[1], port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(floZer1.ports[1], port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
end NoConnection;
