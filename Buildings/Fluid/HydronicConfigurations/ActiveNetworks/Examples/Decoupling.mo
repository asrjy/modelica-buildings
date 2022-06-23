within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model Decoupling
  "Model illustrating the operation of a decoupling circuit"
  extends BaseClasses.PartialDecoupling(del2(nPorts=4));

equation
  connect(con.port_b2, jun.port_1)
    annotation (Line(points={{4,20},{4,60},{10,60}}, color={0,127,255}));
  connect(con.port_a2, del2.ports[4])
    annotation (Line(points={{16,20},{16,40},{40,40}},   color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/Decoupling.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of a decoupling circuit
that serves as the interface between a variable flow primary circuit
and a variable flow consumer circuit operated in change-over.
Two identical terminal units are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions: UPDATE
</ul>

</html>"));
end Decoupling;
