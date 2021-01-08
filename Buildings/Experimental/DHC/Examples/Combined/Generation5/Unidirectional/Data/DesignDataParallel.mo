within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Data;
record DesignDataParallel
  "Record with design data for parallel network"
  extends Modelica.Icons.Record;
  parameter Integer nBui = 3
    "Number of served buildings"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 95
    "Nominal mass flow rate of the distribution pump";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nBui]
    "Nominal mass flow rate in each connection line";
  parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45
    "Plant HX nominal mass flow rate (primary = secondary)";
  parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105
    "Storage nominal mass flow rate";
  final parameter Real facDiv = mDis_flow_nominal / sum(mCon_flow_nominal)
    "Diversity factor used to size the distribution system";
  final parameter Modelica.SIunits.MassFlowRate mDisCon_flow_nominal[nBui]=cat(
    1,
    {mDis_flow_nominal},
    {mDis_flow_nominal - facDiv * 0.9 * sum(mCon_flow_nominal[1:i]) for i in 1:(nBui-1)})
    "Nominal mass flow rate in the distribution line before each connection";
  parameter Modelica.SIunits.MassFlowRate mEnd_flow_nominal=
    0.1 * mDis_flow_nominal
    "Nominal mass flow rate in the end of the distribution line";
  parameter Modelica.SIunits.PressureDifference dpPla_nominal = 50000
    "Plant HX pressure drop at nomninal flow rate (primary = secondary)";
  parameter Real epsPla = 0.935
    "Plant HX effectiveness (constant)";
  parameter Modelica.SIunits.Temperature TLooMin = 273.15 + 6
    "Minimum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMax = 273.15 + 17
    "Maximum loop temperature";
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.SIunits.Length lDis[nBui] = fill(100, nBui)
    "Length of distribution pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lCon[nBui] = fill(10, nBui)
    "Length of connection pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lEnd = 0
    "Length of the end of the distribution line (supply only, not counting return line)";
  annotation (
    defaultComponentPrefix="datDes",
    defaultComponentPrefixes="inner");
end DesignDataParallel;