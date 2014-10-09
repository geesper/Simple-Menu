function New-Menu() {
   param(
   [parameter (Mandatory=$true)] [string] $title,
   [parameter (Mandatory=$false)] [string] $displayText,
   [parameter (Mandatory=$false)] [hashtable] $selections = @{},
   [parameter (Mandatory=$false)] [int] $padding = 2,
   [parameter (Mandatory=$false)] [int] $selected = 0,
   [parameter (Mandatory=$false)] [string] $highLightBGColor = "white",
   [parameter (Mandatory=$false)] [string] $highLightFGColor = "black"
   )

   $tempObject = New-Object psobject -property @{
      Title = $title
      DisplayText = $displayText
      Selections = $selections
      Padding = $padding
      Startline = 5
      Selected = $selected
      ScreenCleared = $false
      HighLightBGColor = $highLightBGColor
      HighLightFGColor = $highLightFGColor
   }
   $validcolors = @("red","blue","cyan", "darkblue", "darkgreen", "darkcyan", "darkred", "darkmagenta", "darkyellow", "gray", "darkgray", "green", "magenta", "yellow", "white", "black")
   if (($validcolors -notcontains $highLightBGColor.tolower()) -or ($validcolors -notcontains $highLightFGColor.tolower())) {
      $tempObject.highLightBGColor = "white"
      $tempObject.highLightFGColor = "black"
   }
   add-member -inputobject $tempObject -type scriptmethod -name addSelection -value { param([hashtable] $newSelection) $this.selections += $newSelection }
   add-member -inputobject $tempObject -type scriptmethod -name getTotalSelections -value { $this.selections.keys.count }
   add-member -inputobject $tempObject -type scriptmethod -name drawSelections -value {
      $this.displayTitle()
      $i = 0
      $currentline = $this.startline
      if ($this.displayText -ne "") {
         $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 2,$currentline
         write-host $this.displayText
         $currentline = $currentline + (($this.displayText.split("`n")).count + 1)
      }

      foreach ($selection in ($this.selections.keys | Sort)) {
         $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 4,$currentline
         if ($i -eq $this.selected) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 4,$currentline
            write-host " $selection " -NoNewline -BackgroundColor $this.highLightBGColor -ForegroundColor $this.highLightFGColor
         } else {
            write-host " $selection " -NoNewline
         }
         $currentline = $currentline + $this.padding
         $i++
      }
   }

   add-member -inputobject $tempObject -type scriptmethod -name drawMenu -value {
      $Host.UI.RawUI.CursorSize = 0
      if ($this.ScreenCleared -ne $true) {
         clear
      } else {
         $this.ScreenCleared = $true
      }

      $this.drawselections()
      while ($exit -ne $true) {
         $ok = $Host.UI.RawUI.ReadKey("IncludeKeyDown,NoEcho")
         switch ($ok.virtualkeycode) {

            38 { $this.selected-- ; if ($this.selected -lt 0) { $this.selected = 0}; $this.drawselections() }   # up
            40 { $this.selected++ ; if ($this.selected -eq $this.gettotalselections()) { $this.selected = $this.gettotalselections() - 1}; $this.drawselections() }   # down
            13 { $this.returnvalue(); $exit = $true }   # enter
            default {
               #$exit = $true
            }
         }
      }
      $Host.UI.RawUI.CursorSize = 25
   }

   add-member -inputobject $tempObject -type scriptmethod -name returnValue -value {
      try {
         $temparray = $this.selections.keys | Sort
         return $this.selections.get_item($temparray[$this.selected])
      } catch {
         return 0
      }
   }

   add-member -inputobject $tempObject -type scriptmethod -name displayTitle -value {
      $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0
      $lines = "  -----------------------------------------------------------------"
      $padding = " " * [int](($lines.length - $content.length) / 2)
      write-host $lines
      write-host $padding $this.title
      write-host $lines `n
   }

   return $tempObject
}

export-modulemember -function New-Menu