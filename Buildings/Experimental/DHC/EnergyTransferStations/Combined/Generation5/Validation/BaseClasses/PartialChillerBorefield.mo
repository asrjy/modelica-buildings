within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Validation.BaseClasses;
partial model PartialChillerBorefield
  "Partial validation of the ETS model with heat recovery chiller and optional borefield"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=0.9*datChi.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=0.9*datChi.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=-1e6
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=abs(
    QCoo_flow_nominal)*(1+1/datChi.COP_nominal)
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=QCoo_flow_nominal,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=abs(
      QCoo_flow_nominal)/5/4186,
    mCon_flow_nominal=QHea_flow_nominal/5/4186,
    TEvaLvg_nominal=277.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={-0.14,-0.03,0,+0.03,0,0},
    EIRFunPLR={0.1,0.9,0},
    TEvaLvgMin=277.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=298.15,
    TConEntMax=328.15)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Fluid.Sources.Boundary_pT heaWat(
    redeclare package Medium=Medium,
    nPorts=1)
    "Heating water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={40,14})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare package Medium=Medium,
    m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-60,40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare package Medium=Medium,
    m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={90,40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-60,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={90,-40})));
  replaceable Combined.Generation5.ChillerBorefield ets(
    redeclare package MediumBui=Medium,
    redeclare package MediumDis=Medium,
    QChiWat_flow_nominal=QCoo_flow_nominal,
    QHeaWat_flow_nominal=QHea_flow_nominal,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    QHex_flow_nominal=-QCoo_flow_nominal,
    T_a1Hex_nominal=284.15,
    T_b1Hex_nominal=279.15,
    T_a2Hex_nominal=277.15,
    T_b2Hex_nominal=282.15,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3,
    datChi=datChi,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1)
    "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
  Fluid.Sources.Boundary_pT disWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-140})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumChiWat(
    redeclare package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3)
    "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=mChiWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{92,70},{112,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=mHeaWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumHeaWat(
    redeclare package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3)
    "Heating water distribution pump"
    annotation (Placement(transformation(extent={{30,30},{10,50}})));
  Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=45+273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium=Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts=2)
    "Volume for heating water distribution circuit"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-111,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(
    final k=-ets.QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=7+273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium=Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts=2)
    "Volume for chilled water distribution circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={149,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(
    final k=-ets.QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,50},{162,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold uHea(
    final t=0.01,
    final h=0.005)
    "Enable heating"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold uCoo(
    final t=0.01,
    final h=0.005)
    "Enable cooling"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Modelica.Blocks.Routing.RealPassThrough heaLoaNor
    "Connect with normalized heating load"
    annotation (Placement(transformation(extent={{-250,50},{-230,70}})));
  Modelica.Blocks.Routing.RealPassThrough loaCooNor
    "Connect with normalized cooling load"
    annotation (Placement(transformation(extent={{270,50},{250,70}})));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
      0,11;
      49,11;
      50,20;
      100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableName="tab1",
    table=[
      0,0,0;
      1,0,0;
      2,0,1;
      3,0,1;
      4,0,0.5;
      5,0,0.5;
      6,0,0.1;
      7,0,0.1;
      8,0,0;
      9,0,0;
      10,0,0;
      11,0,0;
      12,1,0;
      13,1,0;
      14,0.5,0;
      15,0.5,0;
      16,0.1,0;
      17,0.1,0;
      18,0,0;
      19,0,0;
      20,0,0;
      21,0,0;
      22,1,1;
      23,1,1;
      24,0.5,0.5;
      25,0.5,0.5;
      26,0.1,0.1;
      27,0.1,0.1;
      28,0,0;
      29,0,0;
      30,0,0;
      31,0,0;
      32,0.1,1;
      33,0.1,1;
      34,0.5,0.5;
      35,0.5,0.5;
      36,1,0.1;
      37,1,0.1;
      38,0,0;
      39,0,0;
      40,0,0;
      41,0,0;
      42,0.1,0.3;
      43,0.1,0.3;
      44,0.3,0.1;
      45,0.3,0.1;
      46,0.1,0.1;
      47,0.1,0.1;
      48,0,0;
      49,0,0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={0,0},
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));
equation
  connect(senTHeaWatRet.port_b,ets.ports_aHeaWat[1])
    annotation (Line(points={{-50,-40},{-40,-40},{-40,-28},{-10,-28}},color={0,127,255}));
  connect(ets.ports_bChiWat[1],senTChiWatSup.port_a)
    annotation (Line(points={{50,-38},{64,-38},{64,40},{80,40}},color={0,127,255}));
  connect(ets.ports_aChiWat[1],senTChiWatRet.port_b)
    annotation (Line(points={{-10,-38},{-20,-38},{-20,0},{70,0},{70,-40},{80,-40}},color={0,127,255}));
  connect(TChiWatSupSet.y,ets.TChiWatSupSet)
    annotation (Line(points={{-118,100},{-32,100},{-32,-70},{-14,-70}},color={0,0,127}));
  connect(THeaWatSupSet.y,ets.THeaWatSupSet)
    annotation (Line(points={{-118,140},{-28,140},{-28,-62},{-14,-62}},color={0,0,127}));
  connect(disWat.ports[1],ets.port_aDis)
    annotation (Line(points={{-100,-138},{-100,-80},{-10,-80}},color={0,127,255}));
  connect(ets.port_bDis,disWat.ports[2])
    annotation (Line(points={{50,-80},{160,-80},{160,-180},{-100,-180},{-100,-142}},color={0,127,255}));
  connect(pumChiWat.port_a,senTChiWatSup.port_b)
    annotation (Line(points={{110,40},{100,40}},color={0,127,255}));
  connect(gai2.y,pumChiWat.m_flow_in)
    annotation (Line(points={{114,80},{120,80},{120,52}},color={0,0,127}));
  connect(ets.ports_bHeaWat[1],pumHeaWat.port_a)
    annotation (Line(points={{50,-28},{60,-28},{60,40},{30,40}},color={0,127,255}));
  connect(pumHeaWat.port_b,senTHeaWatSup.port_a)
    annotation (Line(points={{10,40},{-50,40}},color={0,127,255}));
  connect(gai1.y,pumHeaWat.m_flow_in)
    annotation (Line(points={{28,80},{20,80},{20,52}},color={0,0,127}));
  connect(gai3.y,loaHea.Q_flow)
    annotation (Line(points={{-158,60},{-140,60}},color={0,0,127}));
  connect(loaHea.port,volHeaWat.heatPort)
    annotation (Line(points={{-120,60},{-112,60},{-112,10},{-111,10}},color={191,0,0}));
  connect(pumChiWat.port_b,volChiWat.ports[1])
    annotation (Line(points={{130,40},{139,40},{139,2}},color={0,127,255}));
  connect(volChiWat.ports[2],senTChiWatRet.port_a)
    annotation (Line(points={{139,-2},{139,-40},{100,-40}},color={0,127,255}));
  connect(senTHeaWatSup.port_b,volHeaWat.ports[1])
    annotation (Line(points={{-70,40},{-101,40},{-101,2}},color={0,127,255}));
  connect(gai4.y,loaCoo.Q_flow)
    annotation (Line(points={{198,60},{182,60}},color={0,0,127}));
  connect(loaCoo.port,volChiWat.heatPort)
    annotation (Line(points={{162,60},{149,60},{149,10}},color={191,0,0}));
  connect(volHeaWat.ports[2],senTHeaWatRet.port_a)
    annotation (Line(points={{-101,-2},{-101,-40},{-70,-40}},color={0,127,255}));
  connect(heaWat.ports[1],pumHeaWat.port_a)
    annotation (Line(points={{40,24},{40,40},{30,40}},color={0,127,255}));
  connect(heaLoaNor.y,gai3.u)
    annotation (Line(points={{-229,60},{-182,60}},color={0,0,127}));
  connect(heaLoaNor.y,uHea.u)
    annotation (Line(points={{-229,60},{-220,60},{-220,-20},{-202,-20}},color={0,0,127}));
  connect(heaLoaNor.y,gai1.u)
    annotation (Line(points={{-229,60},{-220,60},{-220,120},{60,120},{60,80},{52,80}},color={0,0,127}));
  connect(loaCooNor.y,gai4.u)
    annotation (Line(points={{249,60},{222,60}},color={0,0,127}));
  connect(loaCooNor.y,gai2.u)
    annotation (Line(points={{249,60},{240,60},{240,120},{80,120},{80,80},{90,80}},color={0,0,127}));
  connect(loaCooNor.y,uCoo.u)
    annotation (Line(points={{249,60},{240,60},{240,-120},{-220,-120},{-220,-100},{-202,-100}},color={0,0,127}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-309,-140},{-140,-140},{-140,-136},{-122,-136}},color={0,0,127}));
  connect(uCoo.y,ets.uCoo)
    annotation (Line(points={{-178,-100},{-120,-100},{-120,-54},{-14,-54}},color={255,0,255}));
  connect(uHea.y,ets.uHea)
    annotation (Line(points={{-178,-20},{-120,-20},{-120,-46},{-14,-46}},color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-340,-220},{340,220}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p>
This is a partial model used as a base class to construct the
validation and example models.
</p>
</html>"));
end PartialChillerBorefield;
