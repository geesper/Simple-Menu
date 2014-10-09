Simple-Menu is a Powershell module for creating a simple text based menu.
=========================================================================

Description:

I was in need of a way to present a simple menu for console-based scripts, so I developed this very simple framework that will display a title, some text to describe the selections, and the selections. Once you hit enter on the selection you want, it will return a value you have assigned to that selection.

Once imported, a simple usage would be like this:

$mymenu = New-Menu -title "Selection Menu" -padding 1 -selections @{"Selection 1" = 1; "Selection 2" = 2; "Selection 3" = 3; "Potato" = "potato"} -displaytext "Please choose one of the options below."
$myvalue = $mymenu.drawMenu()

This will display a menu, like this:

  -----------------------------------------------------------------
                                   Selection Menu
  -----------------------------------------------------------------


  Please choose one of the options below.

     Potato
     Selection 1
     Selection 2
     Selection 3



In this example, once you hit enter on a selection, the return value would be passed to $myvalue. Choosing "Selection 1" will return 1, "Selection 2" returns 2, "Selection 3" returns 3, and "Potato" returns "potato".

Full Syntax and parameters:
New Menu -title <Title Name> -DisplayText <Text displayed between title and selections> -Selections <Hash indicating selection name and corresponding return value> -HighLightBGColor <color> -HighLightFGColor <color> -Padding <Int value>

