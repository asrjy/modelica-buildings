within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDampersAirflow
  "Separate dedicated OA dampers with AFMS"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersAirflow,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Dampers.Modulating damOut(
    redeclare final package Medium = MediumAir,
    final dat=dat.damOut)
    "Economizer outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Buildings.Templates.Components.Dampers.Modulating damOutMin(
    redeclare final package Medium = MediumAir,
    final dat=dat.damOutMin)
    "Minimum outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,60})));

  Buildings.Templates.Components.Sensors.Temperature TAirOut(
    redeclare final package Medium =  MediumAir,
    final have_sen=true,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VAirOutMin_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=mOutMin_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Minimum outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
    final have_sen=
      typCtlEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
      typCtlEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(damOutMin.bus, bus.damOutMin);
  connect(TAirOut.y, bus.TAirOut);
  connect(hAirOut.y, bus.hAirOut);
  connect(VAirOutMin_flow.y, bus.VAirOutMin_flow);
  /* Control point connection - end */
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(TAirOut.port_b, VAirOutMin_flow.port_a)
    annotation (Line(points={{90,60},{110,60}},color={0,127,255}));
  connect(VAirOutMin_flow.port_b, port_b) annotation (Line(points={{130,60},{160,
          60},{160,0},{180,0}},
                            color={0,127,255}));
  connect(damOutMin.port_b, hAirOut.port_a)
    annotation (Line(points={{10,60},{30,60}}, color={0,127,255}));
  connect(hAirOut.port_b, TAirOut.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-10,0}}, color={0,127,255}));
  connect(damOutMin.port_a, damOut.port_a) annotation (Line(points={{-10,60},{
          -20,60},{-20,0},{-10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulating in case
of AFMS.
</p>
</html>"), Icon(graphics={
              Line(
          points={{0,140},{0,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,60},{0,60}},
          color={28,108,200},
          thickness=1)}));
end DedicatedDampersAirflow;
