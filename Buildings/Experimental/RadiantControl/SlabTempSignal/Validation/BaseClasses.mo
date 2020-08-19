within Buildings.Experimental.RadiantControl.SlabTempSignal.Validation;
package BaseClasses "Base classes for validation models"
  block ForecastHighChicago
    "Outputs next-day forecast high temperature for Chicago"
    Utilities.Time.ModelTime modTim1 "Model timer for forecast high"
      annotation (Placement(transformation(extent={{32,26},{52,46}})));
    Controls.SetPoints.Table           ForecastHigh(table=[86400,273.75;
          172800,272.55; 259200,269.85; 345600,262.05; 432000,260.35; 518400,
          264.85; 604800,274.85; 691200,275.35; 777600,277.55; 864000,277.05;
          950400,268.15; 1036800,270.35; 1123200,275.95; 1209600,283.15;
          1296000,284.85; 1382400,280.35; 1468800,275.35; 1555200,274.85;
          1641600,285.35; 1728000,276.45; 1814400,277.05; 1900800,275.95;
          1987200,275.95; 2073600,266.45; 2160000,258.15; 2246400,265.35;
          2332800,266.45; 2419200,267.55; 2505600,272.05; 2592000,268.15;
          2678400,272.55; 2764800,272.55; 2851200,272.55; 2937600,261.45;
          3024000,263.75; 3110400,264.25; 3196800,269.25; 3283200,278.15;
          3369600,281.45; 3456000,287.05; 3542400,279.85; 3628800,275.35;
          3715200,272.05; 3801600,268.75; 3888000,269.85; 3974400,276.45;
          4060800,279.85; 4147200,273.15; 4233600,272.55; 4320000,275.35;
          4406400,284.85; 4492800,287.55; 4579200,283.75; 4665600,277.55;
          4752000,274.85; 4838400,273.15; 4924800,275.95; 5011200,279.25;
          5097600,278.15; 5184000,274.85; 5270400,283.15; 5356800,270.95;
          5443200,274.85; 5529600,279.85; 5616000,284.25; 5702400,284.85;
          5788800,289.85; 5875200,283.75; 5961600,282.55; 6048000,276.45;
          6134400,282.05; 6220800,282.05; 6307200,283.15; 6393600,275.35;
          6480000,280.35; 6566400,290.35; 6652800,278.75; 6739200,281.45;
          6825600,280.95; 6912000,279.85; 6998400,278.15; 7084800,279.85;
          7171200,290.95; 7257600,294.25; 7344000,288.15; 7430400,286.45;
          7516800,276.45; 7603200,280.95; 7689600,277.55; 7776000,279.85;
          7862400,277.55; 7948800,275.35; 8035200,278.15; 8121600,279.25;
          8208000,282.55; 8294400,284.25; 8380800,283.15; 8467200,290.95;
          8553600,297.05; 8640000,292.05; 8726400,289.85; 8812800,297.55;
          8899200,304.25; 8985600,303.75; 9072000,302.05; 9158400,304.25;
          9244800,292.55; 9331200,281.45; 9417600,278.75; 9504000,279.25;
          9590400,288.75; 9676800,295.95; 9763200,285.35; 9849600,283.75;
          9936000,284.85; 10022400,288.15; 10108800,289.25; 10195200,288.15;
          10281600,289.85; 10368000,297.05; 10454400,297.55; 10540800,303.15;
          10627200,303.75; 10713600,295.95; 10800000,286.45; 10886400,285.35;
          10972800,290.95; 11059200,295.35; 11145600,291.45; 11232000,290.35;
          11318400,293.15; 11404800,288.15; 11491200,289.25; 11577600,289.85;
          11664000,286.45; 11750400,289.25; 11836800,292.05; 11923200,296.45;
          12009600,300.35; 12096000,300.95; 12182400,297.05; 12268800,298.15;
          12355200,300.35; 12441600,295.95; 12528000,302.55; 12614400,302.55;
          12700800,300.35; 12787200,302.55; 12873600,298.15; 12960000,298.15;
          13046400,298.15; 13132800,302.05; 13219200,303.75; 13305600,294.25;
          13392000,305.35; 13478400,299.85; 13564800,306.45; 13651200,299.85;
          13737600,296.45; 13824000,298.75; 13910400,295.35; 13996800,295.95;
          14083200,303.15; 14169600,304.85; 14256000,304.25; 14342400,298.15;
          14428800,292.05; 14515200,302.05; 14601600,305.35; 14688000,303.75;
          14774400,297.55; 14860800,288.15; 14947200,293.75; 15033600,299.85;
          15120000,303.75; 15206400,303.75; 15292800,303.15; 15379200,299.85;
          15465600,300.35; 15552000,292.05; 15638400,297.05; 15724800,297.55;
          15811200,303.75; 15897600,305.95; 15984000,305.95; 16070400,302.05;
          16156800,301.45; 16243200,296.45; 16329600,297.55; 16416000,298.75;
          16502400,300.95; 16588800,302.05; 16675200,298.15; 16761600,305.35;
          16848000,306.45; 16934400,307.05; 17020800,307.05; 17107200,308.15;
          17193600,302.55; 17280000,300.95; 17366400,302.55; 17452800,304.25;
          17539200,305.35; 17625600,303.15; 17712000,300.95; 17798400,304.85;
          17884800,303.15; 17971200,300.95; 18057600,302.55; 18144000,304.85;
          18230400,300.95; 18316800,302.55; 18403200,304.85; 18489600,304.25;
          18576000,303.15; 18662400,294.85; 18748800,294.85; 18835200,298.15;
          18921600,300.35; 19008000,301.45; 19094400,299.85; 19180800,301.45;
          19267200,301.45; 19353600,298.75; 19440000,297.55; 19526400,296.45;
          19612800,298.75; 19699200,298.15; 19785600,299.25; 19872000,302.05;
          19958400,303.75; 20044800,302.05; 20131200,295.95; 20217600,295.95;
          20304000,298.15; 20390400,299.85; 20476800,301.45; 20563200,301.45;
          20649600,302.55; 20736000,300.95; 20822400,301.45; 20908800,298.75;
          20995200,293.75; 21081600,295.35; 21168000,302.05; 21254400,304.25;
          21340800,303.15; 21427200,297.05; 21513600,299.85; 21600000,299.25;
          21686400,299.85; 21772800,300.35; 21859200,299.25; 21945600,293.75;
          22032000,297.05; 22118400,299.25; 22204800,295.35; 22291200,294.85;
          22377600,293.15; 22464000,294.85; 22550400,289.85; 22636800,289.25;
          22723200,294.25; 22809600,297.55; 22896000,293.75; 22982400,293.75;
          23068800,302.05; 23155200,304.85; 23241600,300.35; 23328000,292.05;
          23414400,292.05; 23500800,292.55; 23587200,295.95; 23673600,292.55;
          23760000,289.85; 23846400,288.75; 23932800,286.45; 24019200,285.35;
          24105600,287.55; 24192000,295.95; 24278400,289.85; 24364800,289.85;
          24451200,289.85; 24537600,289.85; 24624000,283.15; 24710400,283.75;
          24796800,285.35; 24883200,287.05; 24969600,288.15; 25056000,288.75;
          25142400,295.95; 25228800,299.25; 25315200,295.95; 25401600,284.25;
          25488000,286.45; 25574400,289.25; 25660800,285.35; 25747200,290.35;
          25833600,286.45; 25920000,287.55; 26006400,293.75; 26092800,286.45;
          26179200,288.75; 26265600,294.85; 26352000,294.25; 26438400,288.15;
          26524800,286.45; 26611200,288.15; 26697600,287.55; 26784000,290.35;
          26870400,291.45; 26956800,276.45; 27043200,277.05; 27129600,275.95;
          27216000,277.55; 27302400,284.85; 27388800,288.75; 27475200,284.85;
          27561600,280.35; 27648000,279.25; 27734400,280.95; 27820800,288.15;
          27907200,275.35; 27993600,277.05; 28080000,276.45; 28166400,277.05;
          28252800,273.15; 28339200,265.95; 28425600,270.95; 28512000,268.15;
          28598400,273.75; 28684800,276.25; 28771200,281.45; 28857600,274.85;
          28944000,277.55; 29030400,277.05; 29116800,276.45; 29203200,280.35;
          29289600,284.25; 29376000,276.45; 29462400,271.45; 29548800,272.55;
          29635200,273.15; 29721600,275.35; 29808000,275.35; 29894400,273.75;
          29980800,267.55; 30067200,267.55; 30153600,268.15; 30240000,267.55;
          30326400,265.35; 30412800,267.55; 30499200,273.75; 30585600,273.75;
          30672000,272.55; 30758400,271.45; 30844800,274.25; 30931200,274.25;
          31017600,272.55; 31104000,270.95; 31190400,265.35; 31276800,271.45;
          31363200,275.95; 31449600,275.95])
      "Forecast high lookup table: x axis time in seconds, y axis forecast high temperature"
      annotation (Placement(transformation(extent={{-6,-30},{-48,12}})));
    Controls.OBC.CDL.Interfaces.RealOutput TForecastHigh
      "Forecasted high temperature"
      annotation (Placement(transformation(extent={{100,-18},{140,22}})));
  equation
    connect(modTim1.y,ForecastHigh. u) annotation (Line(points={{53,36},{70,
            36},{70,-9},{-1.8,-9}},   color={0,0,127}));
    connect(ForecastHigh.y, TForecastHigh) annotation (Line(points={{-50.1,
            -9},{-76,-9},{-76,-80},{84,-80},{84,2},{120,2}}, color={0,0,127}));
    annotation (defaultComponentName = "ForecastHighChicago",Documentation(info="<html>
<p>
This outputs the next-day high temperature for Chicago, so that an appropriate radiant slab setpoint can be chosen from the lookup table. 
</p>
</html>"),  Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Text(
            lineColor={0,0,255},
            extent={{-150,110},{150,150}},
            textString="%name"),  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,-150},{150,-110}},
            lineColor={0,0,0},
            textString="duration=%duration"),
         Text(
            extent={{-72,78},{102,6}},
            lineColor={0,0,0},
            fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="F"),
          Text(
            extent={{226,60},{106,10}},
            lineColor={0,0,0},
            textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ForecastHighChicago;

  block SlabSetCore "Determines slab temperature setpoint for core zones"
    parameter Real TSlaCor(min=0,
      final unit="K",
      final displayUnit="K",
      final quantity="Temperature")=294.3;

    Controls.OBC.CDL.Interfaces.RealOutput TSlaSetCor
      "Slab temperature setpoint for a core zone"
      annotation (Placement(transformation(extent={{100,-10},{140,30}})));
    Controls.OBC.CDL.Continuous.Sources.Constant TSlabCore(k=TSlaCor)
      "Slab setpoint for core zones"
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation
    connect(TSlabCore.y, TSlaSetCor)
      annotation (Line(points={{22,10},{120,10}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This outputs a user-selected constant setpoint for a core zone.
</p>
</html>"),  Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Text(
            lineColor={0,0,255},
            extent={{-150,110},{150,150}},
            textString="%name"),  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,-150},{150,-110}},
            lineColor={0,0,0},
            textString="duration=%duration"),
         Text(
            extent={{-72,78},{102,6}},
            lineColor={0,0,0},
            fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Sc"),
          Text(
            extent={{226,60},{106,10}},
            lineColor={0,0,0},
            textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SlabSetCore;

  package Validation "Validation models for output-only blocks"

    model ForHiChi "Validation model for forecast high temperature for Chicago"
      ForecastHighChicago forecastHighChicago
        annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
      annotation (experiment(Tolerance=1E-06, StopTime=172800),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTempSignal/Validation/BaseClasses/Validation/ForHiChi.mos"
            "Simulate and plot"), Documentation(info="<html>
<p>
This validates the Chicago forecast high. 
</p>
</html>"),    Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ForHiChi;

    model SlaSetCor "Validation model for slab temperature error block"

        final parameter Real TSlaSetCor(min=0,
        final unit="K",
        final displayUnit="K",
        final quantity="Temperature")=294.3;
      Buildings.Experimental.RadiantControl.SlabTempSignal.Validation.BaseClasses.SlabSetCore
        slabSetCore(TSlaCor=TSlaSetCor)
        annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
      annotation (Documentation(info="<html>
<p>
This validates the slab setpoint for a core zone. 
</p>
</html>"),    experiment(StopTime=31536000.0, Tolerance=1e-06),Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end SlaSetCor;
  end Validation;
end BaseClasses;
