within Buildings.Experimental.Templates.AHUs.Coils.Data;
record CoolingWater
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)=1
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=1
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpWat_nominal(
    displayUnit="Pa")=3e4
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=200
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  replaceable parameter HeatExchangers.Data.None datHex
    constrainedby HeatExchangers.Data.None
    "Heat exchanger data"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typHex<>Types.HeatExchanger.None,
        group="Heat Exchanger"));

  annotation (
    defaultComponentName="datCoiCoo",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
