within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialOpenTank "(Draft)"

  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant;

  Buildings.Fluid.Storage.Plant.SupplyPumpOpenTank supPum(redeclare final
      package Medium = Medium, final nom=nom) "Supply pump and valves"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation

  connect(mSinChi_flow.y, sinChi.m_flow_in)
    annotation (Line(points={{-79,0},{-70,0},{-70,-22},{-62,-22}},
                                                          color={0,0,127}));
  connect(tanBra.port_CHWS, supPum.port_chiOut)
    annotation (Line(points={{-10,6},{10,6}}, color={0,127,255}));
  connect(supPum.port_CHWS, sin.ports[1]) annotation (Line(points={{30,6},{34,6},
          {34,30},{40,30}}, color={0,127,255}));
  connect(tanBra.port_CHWR, supPum.port_chiInl)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(supPum.port_CHWR, sou.ports[1]) annotation (Line(points={{30,-6},{34,
          -6},{34,-30},{40,-30}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Documentation pending.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialOpenTank;