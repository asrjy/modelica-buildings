within Buildings.HeatTransfer.WindowsBeta.BaseClasses;
record RadiationData "Radiation property of a window"
  extends Modelica.Icons.Record;
  extends Buildings.HeatTransfer.WindowsBeta.BaseClasses.RadiationBaseData;

  final parameter Real glass[3, N]={tauGlaSW,rhoGlaSW_a,rhoGlaSW_b}
    "Glass solar transmissivity, solar reflectivity at surface a and b, at normal incident angle";

  final parameter Real traRefShaDev[2, 2]={{tauShaSW_a,tauShaSW_b},{rhoShaSW_a,
      rhoShaSW_b}} "Shading device property";
  final parameter Integer NDIR=10 "Number of incident angles";
  final parameter Integer HEM=NDIR + 1 "Index of hemispherical integration";
  final parameter Modelica.SIunits.Angle psi[NDIR]=
      Buildings.HeatTransfer.WindowsBeta.Functions.getAngle(NDIR)
    "Incident angles used for solar radiation calculation";
  final parameter Real layer[3, N, HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassProperty(
      N,
      HEM,
      glass,
      psi) "Angular and hemispherical transmissivity, front (outside-facing) and back (room facing) reflectivity 
      of each glass pane";
  final parameter Real traRef[3, N, N, HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.getGlassTR(
      N,
      HEM,
      layer) "Angular and hemispherical transmissivity, front (outside-facing) and back (room facing) reflectivity 
      between glass panes for exterior or interior irradiation without shading";
  final parameter Real absExtIrrNoSha[N, HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsExteriorIrradiationNoShading(
      traRef,
      N,
      HEM) "Angular and hemispherical absorptivity of each glass pane 
      for exterior irradiation without shading";
  final parameter Real absIntIrrNoSha[N]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsInterirorIrradiationNoShading(
      traRef,
      N,
      HEM) "Hemispherical absorptivity of each glass pane 
      for interior irradiation without shading";
  final parameter Real winTraExtIrrExtSha[HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.winTExteriorIrradiatrionExteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM) "Angular and hemispherical transmissivity of a window system (glass + exterior shading device) 
     for exterior irradiation";
  final parameter Real absExtIrrExtSha[N, HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsExteriorIrradiationExteriorShading(
      absExtIrrNoSha,
      traRef,
      traRefShaDev,
      N,
      HEM) "Angular and hemispherical absorptivity of each glass pane 
      for exterior irradiation with exterior shading";
  final parameter Real winTraExtIrrIntSha[HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.winTExteriorIrradiationInteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM) "Angular and hemispherical transmissivity of a window system (glass and interior shading device) 
      for exterior irradiation";
  final parameter Real absExtIrrIntSha[N, HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsExteriorIrradiationInteriorShading(
      absExtIrrNoSha,
      traRef,
      traRefShaDev,
      N,
      HEM) "Angular and hemispherical absorptivity of each glass layer
     for exterior irradiation with interior shading";
  final parameter Real devAbsExtIrrIntShaDev[HEM]=
      Buildings.HeatTransfer.WindowsBeta.Functions.devAbsExteriorIrradiationInteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM) "Angular and hemispherical absorptivity of an interior shading device 
      for exterior irradiation";
  final parameter Real winTraRefIntIrrExtSha[3]=
      Buildings.HeatTransfer.WindowsBeta.Functions.winTRInteriorIrradiationExteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM) "Hemisperical transmissivity and reflectivity of a window system (glass and exterior shadig device) 
      for interior irradiation. traRefIntIrrExtSha[1]: transmissivity, 
      traRefIntIrrExtSha[2]: Back reflectivity; traRefIntIrrExtSha[3]: dummy value";
  final parameter Real absIntIrrExtSha[N]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsInteriorIrradiationExteriorShading(
      absIntIrrNoSha,
      traRef,
      traRefShaDev,
      N,
      HEM) "Hemispherical absorptivity of each glass pane 
      for interior irradiation with exterior shading";
  final parameter Real absIntIrrIntSha[N]=
      Buildings.HeatTransfer.WindowsBeta.Functions.glassAbsInteriorIrradiationInteriorShading(
      absIntIrrNoSha,
      traRef,
      traRefShaDev,
      N,
      HEM) "Hemispherical absorptivity of each glass pane 
      for interior irradiation with interior shading";
  final parameter Real winTraRefIntIrrIntSha[3]=
      Buildings.HeatTransfer.WindowsBeta.Functions.winTRInteriorIrradiationInteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM) "Hemisperical transmissivity and back reflectivity of a window system (glass and interior shadig device) 
      for interior irradiation";
  final parameter Real devAbsIntIrrIntSha=
      Buildings.HeatTransfer.WindowsBeta.Functions.devAbsInteriorIrradiationInteriorShading(
      traRef,
      traRefShaDev,
      N,
      HEM)
    "Hemiperical absorptivity of an interior shading device for interior irradiation";
  annotation (Documentation(info="<html>
Record that computes the short-wave radiation data for glazing system.
</html>", revisions="<html>
<ul>
<li>
December 12, 2010, by Michael Wetter:<br>
Replaced record 
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> with the
parameters used by this model.
This was needed to integrate the radiation model into the room model.
</li>
<li>
December 10, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end RadiationData;
