within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  extends
    Buildings.Templates.ChilledWaterPlant.Interfaces.PartialChilledWaterPlant(
      redeclare final package Medium=MediumChiWat,
      final nChi = chiSec.nChi,
      final nPumPri = chiSec.pumPri.nPum,
      final nPumSec = pumSec.nPum,
      final have_parChi = chiSec.is_parallel,
      final have_dedChiWatPum = chiSec.pumPri.is_dedicated,
      final have_secPum = not pumSec.is_none,
      final have_eco = eco.have_eco,
      final typValChiWatChi=chiSec.typValChiWatChiSer,
      busCon(final nChi=nChi),
      dat(
        con(
          typ = con.typ,
          nSenDpChiWatRem = con.nSenDpChiWatRem,
          nChi = con.nChi,
          have_eco = con.have_eco,
          have_sendpChiWatLoc = con.have_sendpChiWatLoc,
          have_fixSpeConWatPum = con.have_fixSpeConWatPum,
          have_ctrHeaPre = con.have_ctrHeaPre),
        chiSec(
          typ = chiSec.typ,
          nChi = chiSec.nChi,
          chi(typ = chiSec.chi.typ)),
        pumPri(
          typ = chiSec.pumPri.typ,
          nPum = chiSec.pumPri.nPum,
          have_byp = chiSec.pumPri.have_byp,
          have_chiByp = chiSec.pumPri.have_chiByp,
          valChiWatChi(typ = typValChiWatChi),
          pum(each typ = chiSec.pumPri.pum.typ)),
        pumSec(
          typ = pumSec.typ,
          nPum = pumSec.nPum),
        eco(typ = eco.typ)));

  replaceable package MediumChiWat=Buildings.Media.Water
    "Chilled water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
    chiSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.chiSec,
      final datPumPri=dat.pumPri,
      final have_TChiWatPlaRet=have_TChiWatPlaRet)
    "Chiller section"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-8})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
    eco constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.eco)
    "Waterside economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-50})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.None
      pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Interfaces.PartialSecondaryPump(
      redeclare final package Medium = MediumChiWat,
      final dat=dat.pumSec)
    "Chilled water secondary pumps"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Controls.OpenLoop
    con constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final dat=dat.con)
    "Plant controller"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,60})));

  Buildings.Templates.Components.Sensors.Temperature TChiWatRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=not have_eco,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{120,-60}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium = MediumChiWat,
    final have_sen=con.have_sendpChiWatLoc,
    final text_rotation=90)
    "Local sensor for chilled water differential pressure - Hardwired to plant controller"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={180,-30})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecSup(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_secPum,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal)
    "Secondary chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat, nPorts=2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,30})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecSup_flow)
    "Secondary chilled water supply flow"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecRet_flow) "Secondary chilled water return flow"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  // FIXME: add icons for OA sensors.
  Modelica.Blocks.Routing.RealPassThrough RHAirOut(
    y(final unit="1", final min=0, final max=1))
    "Outdoor air relative humidity"
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  Modelica.Blocks.Routing.RealPassThrough TAirOut(
    y(final unit="K", displayUnit="degC"))
    "Outdoor air dry-bulb temperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Routing.RealPassThrough TWetAirOut(
    y(final unit="K", displayUnit="degC"))
    "FIXME: Outdoor air wet-bulb temperature (should be computed by controller)"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
equation
  // Sensors
  connect(TChiWatSecSup.y, busCon.TChiWatSecSup);
  connect(TChiWatRet.y, busCon.TChiWatRet);
  connect(dpChiWatLoc.y, busCon.dpChiWatLoc);
  connect(VSecSup_flow.y, busCon.VSecSup_flow);
  connect(VSecRet_flow.y, busCon.VSecRet_flow);
  connect(TAirOut.y, busCon.TAirOut);
  connect(RHAirOut.y, busCon.RHAirOut);
  connect(TWetAirOut.y, busCon.TWetAirOut);

  // Bus connection
  connect(chiSec.busCon, busCon);
  connect(eco.busCon, busCon);
  connect(pumSec.busCon, busCon);

  connect(weaBus.TDryBul, TAirOut.u)
    annotation (Line(
      points={{0,100},{0,80},{18,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.relHum, RHAirOut.u)
    annotation (Line(
      points={{-8.88178e-16,100},{-2,100},{-2,80},{-18,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, TWetAirOut.u)
    annotation (Line(
      points={{0,100},{0,120},{18,120}},
      color={255,204,51},
      thickness=0.5));

  // Controller
  connect(con.busCon, busCon)
    annotation (Line(
      points={{80,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  // Mechanical
  connect(dpChiWatLoc.port_b,port_a)
    annotation (Line(points={{180,-40},{180,-70},{200,-70}}, color={0,127,255}));
  connect(port_a,TChiWatRet.port_a)
    annotation (Line(points={{200,-70},{140,-70}}, color={0,127,255}));
  connect(TChiWatRet.port_b, VSecRet_flow.port_b)
    annotation (Line(points={{120,-70},{100,-70}}, color={0,127,255}));
  connect(VSecRet_flow.port_a, eco.port_a2)
    annotation (Line(points={{80,-70},{6,-70},{6,-60}}, color={0,127,255}));
  connect(eco.port_b2, chiSec.port_a2)
    annotation (Line(points={{6,-40},{6,-29},{6,-29},{6,-18}}, color={0,127,255}));
  connect(chiSec.port_b2, bouChiWat.ports[1])
    annotation (Line(points={{6,2},{6,10},{29,10},{29,20}}, color={0,127,255}));
  connect(bouChiWat.ports[2], pumSec.port_a)
    annotation (Line(points={{31,20},{31,10},{60,10}}, color={0,127,255}));
  connect(pumSec.port_b, VSecSup_flow.port_a)
    annotation (Line(points={{80,10},{100,10}}, color={0,127,255}));
  connect(VSecSup_flow.port_b, TChiWatSecSup.port_a)
    annotation (Line(points={{120,10},{140,10}}, color={0,127,255}));
  connect(TChiWatSecSup.port_b,port_b)
    annotation (Line(points={{160,10},{200,10}}, color={0,127,255}));
  connect(dpChiWatLoc.port_a,port_b)
    annotation (Line(points={{180,-20},{180,10},{200,10}}, color={0,127,255}));

end PartialChilledWaterLoop;