within Buildings.Experimental.DHC.Examples;
model Steam "Example model for a complete steam district heating system"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam (
    p_default=400000,
    T_default=144+273.15)
    "Steam medium";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity (
      p_default=101325,
      T_default=100+273.15)
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=400000
    "Saturation pressure, high pressure";
  parameter Modelica.Units.SI.AbsolutePressure pLow=200000
    "Reduced pressure, after PRV";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature";
  parameter Modelica.Units.SI.SpecificEnthalpy dh_nominal=
    MediumSte.specificEnthalpy(MediumSte.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumSte.X_default)) -
      MediumWat.specificEnthalpy(MediumWat.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumWat.X_default))
    "Nominal change in enthalpy";

  parameter Integer N = 3 "Number of buildings";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal=sum(mBui_flow_nominal)
    "Nominal mass flow rate of entire district";
  parameter Modelica.Units.SI.HeatFlowRate QDis_flow_nominal=QBui_flow_nominal*N
    "Nominal heat flow rate of entire district";
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal[N]=
    fill(QBui_flow_nominal/dh_nominal, N)
    "Nominal mass flow through buildings";
  parameter Modelica.Units.SI.HeatFlowRate QBui_flow_nominal=20000
    "Nominal heat flow rate of each building";
  parameter Modelica.Units.SI.PressureDifference dpPip=6000
    "Pressure drop in the condensate return pipe";

  parameter Buildings.Fluid.Movers.Data.Generic perPumFW(
   pressure(V_flow=mDis_flow_nominal*1000*{0,1,2},
                   dp=(pSat-101325)*{2,1,0}))
    "Performance data for feedwater pump at the plant";

  Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS bld[N](
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    each have_prv=true,
    each dp_nominal=dpPip/2,
    each pSte_nominal=pSat,
    each Q_flow_nominal=QBui_flow_nominal,
    each pLow_nominal=pLow,
    each tableOnFile=false,
    each QHeaLoa=
      [0,0.8; 2,1; 10,1; 12,0.5; 20,0.5; 24,0.8]*[1,0;0,QBui_flow_nominal],
    each smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    each timeScale(displayUnit="s") = 3600,
    each show_T=true)
    "Buildings"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  Buildings.Experimental.DHC.Networks.Steam.DistributionCondensatePipe dis(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    nCon=N,
    mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mBui_flow_nominal)
    "Distribution network"
    annotation (Placement(transformation(extent={{0,-20},{40,0}})));
  Buildings.Experimental.DHC.Plants.Steam.SingleBoiler pla(
    redeclare package Medium = MediumWat,
    redeclare package MediumHea_b = MediumSte,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    m_flow_nominal=mDis_flow_nominal,
    pSteSet=pSat,
    Q_flow_nominal=QDis_flow_nominal,
    per=perPumFW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    controllerTypeBoi=Modelica.Blocks.Types.SimpleController.PI,
    kBoi=600,
    TiBoi(displayUnit="min") = 120,
    initTypeBoi=Modelica.Blocks.Types.Init.InitialOutput,
    yBoiCon_start=0.5,
    controllerTypePum=Modelica.Blocks.Types.SimpleController.PI,
    kPum=200,
    TiPum=1000,
    initTypePum=Modelica.Blocks.Types.Init.InitialOutput,
    yPumCon_start=0.7)
    "Plant"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
equation
  connect(dis.ports_bCon, bld.port_a)
    annotation (Line(points={{8,0},{8,30},{40,30}},      color={0,127,255}));
  connect(bld.port_b, dis.ports_aCon)
    annotation (Line(points={{40,24},{32,24},{32,0}},  color={0,127,255}));
  connect(pla.port_bSerHea, dis.port_aDisSup)
    annotation (Line(points={{-30,30},{-20,30},{-20,-10},{0,-10}},
                                                 color={0,127,255}));
  connect(dis.port_bDisRet, pla.port_aSerHea) annotation (Line(points={{0,-16},{
          -60,-16},{-60,30},{-50,30}},                   color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Steam.mos"
    "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Steam;
