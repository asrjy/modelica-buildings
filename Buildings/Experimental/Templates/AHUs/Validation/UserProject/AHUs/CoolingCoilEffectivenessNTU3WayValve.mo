within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilEffectivenessNTU3WayValve
  extends Templates.AHUs.Main.VAVSingleDuct(
    redeclare record RecordCoiCoo = Coils.Data.WaterBased (redeclare
          Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.EffectivenessNTU
          datHex, redeclare
          Buildings.Experimental.Templates.AHUs.Coils.Actuators.Data.ThreeWayValve
          datAct),
    redeclare replaceable Economizers.None eco
      "No economizer",
    redeclare Coils.WaterBased coiCoo(redeclare
      Buildings.Experimental.Templates.AHUs.Coils.Actuators.ThreeWayValve
      act, redeclare
      Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.EffectivenessNTU
      coi));
  annotation (
    defaultComponentName="ahu");
end CoolingCoilEffectivenessNTU3WayValve;
