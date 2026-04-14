function Invoke-WPFTab {

    <#

    .SYNOPSIS
        Sets the selected tab to the tab that was clicked

    .PARAMETER ClickedTab
        The name of the tab that was clicked

    #>

    Param (
        [Parameter(Mandatory,position=0)]
        [string]$ClickedTab
    )

    $tabItemName = $ClickedTab -replace 'BT$'
    $tabButtons = Get-WinUtilVariables -Type ToggleButton | Where-Object { $_ -match '^WPFTab\d+BT$' }
    foreach ($buttonName in $tabButtons) {
        $sync[$buttonName].IsChecked = ($buttonName -eq $ClickedTab)
    }

    if ($sync[$tabItemName]) {
        $sync[$tabItemName].IsSelected = $true
        $sync.currentTab = [string]$sync[$tabItemName].Header
    } else {
        return
    }

    # Always reset the filter for the current tab
    if ($sync.currentTab -eq "Install") {
        # Reset Install tab filter
        Find-AppsByNameOrDescription -SearchString ""
    } elseif ($sync.currentTab -eq "Tweaks") {
        # Reset Tweaks tab filter
        Find-TweaksByNameOrDescription -SearchString ""
    }

    # Show search bar in Install and Tweaks tabs
    if ($sync.currentTab -eq "Install" -or $sync.currentTab -eq "Tweaks") {
        $sync.SearchBar.Visibility = "Visible"
        $searchIcon = ($sync.Form.FindName("SearchBar").Parent.Children | Where-Object { $_ -is [System.Windows.Controls.TextBlock] -and $_.Text -eq [char]0xE721 })[0]
        if ($searchIcon) {
            $searchIcon.Visibility = "Visible"
        }
    } else {
        $sync.SearchBar.Visibility = "Collapsed"
        $searchIcon = ($sync.Form.FindName("SearchBar").Parent.Children | Where-Object { $_ -is [System.Windows.Controls.TextBlock] -and $_.Text -eq [char]0xE721 })[0]
        if ($searchIcon) {
            $searchIcon.Visibility = "Collapsed"
        }
        # Hide the clear button if it's visible
        $sync.SearchBarClearButton.Visibility = "Collapsed"
    }
}
