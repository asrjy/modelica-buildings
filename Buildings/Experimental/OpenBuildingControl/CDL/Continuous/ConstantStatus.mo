within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block ConstantStatus "Output constant signal of type Status"

  parameter Buildings.Experimental.OpenBuildingControl.CDL.Types.Status refSta
    "Array where each element is a freeze protection stage indicator";
//     refSta={Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage0,
//       Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage1,
//       Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage2,
//       Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage3}

   Interfaces.StatusTypeOutput yFreProSta "Connector of Status type output signal"
     annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
   yFreProSta = refSta;
   annotation (
     defaultComponentName="con",
     Icon(coordinateSystem(
         preserveAspectRatio=true,
         extent={{-100,-100},{100,100}}), graphics={
         Rectangle(
         extent={{-100,-100},{100,100}},
         lineColor={0,0,127},
         fillColor={255,255,255},
         fillPattern=FillPattern.Solid),
         Text(
           lineColor={0,0,255},
           extent={{-150,110},{150,150}},
           textString="%name"),
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
         Line(points={{-80,0},{80,0}}),
         Text(
           extent={{-150,-150},{150,-110}},
           lineColor={0,0,0},
           textString="k=%k")}),
     Diagram(coordinateSystem(
         preserveAspectRatio=true,
         extent={{-100,-100},{100,100}}), graphics={
         Polygon(
           points={{-80,90},{-86,68},{-74,68},{-80,90}},
           lineColor={95,95,95},
           fillColor={95,95,95},
           fillPattern=FillPattern.Solid),
         Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
         Line(
           points={{-80,0},{80,0}},
           color={0,0,255},
           thickness=0.5),
         Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
         Polygon(
           points={{90,-70},{68,-64},{68,-76},{90,-70}},
           lineColor={95,95,95},
           fillColor={95,95,95},
           fillPattern=FillPattern.Solid),
         Text(
           extent={{-83,92},{-30,74}},
           lineColor={0,0,0},
           textString="y"),
         Text(
           extent={{70,-80},{94,-100}},
           lineColor={0,0,0},
           textString="time"),
         Text(
           extent={{-101,8},{-81,-12}},
           lineColor={0,0,0},
           textString="k")}),
     Documentation(info="<html>
 <p>
 Block that outputs a constant signal <code>y = refSta</code>,
 where <code>refSta</code> is a parameter of type Status. The usage of this type
 is to provide reference signal value to compare with an enumerated type input 
 value, for example to evaluate a Freeze Protection Status signal.
 </p>
 <p align=\"center\">
 <img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Continuous/Constant.png\"
      alt=\"Constant.png\" />
 </p>
 </html>"));
end ConstantStatus;
