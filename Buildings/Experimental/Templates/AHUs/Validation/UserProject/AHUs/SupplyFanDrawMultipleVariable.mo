within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model SupplyFanDrawMultipleVariable
  extends Templates.AHUs.Main.VAVSingleDuct(
    redeclare record RecordFanSup = Fans.Data.MultipleVariable,
    have_draThr=true,
    redeclare Fans.MultipleVariable
        fanSupDra);

  annotation (
    defaultComponentName="ahu");
end SupplyFanDrawMultipleVariable;
