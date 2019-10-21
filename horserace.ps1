function print-horses ()
{
    param($positionHorses)
    $stringHorses=0..9 |% {("Horse ${_}: "+ " "*$positionHorses[$_])+"🏇"}
    return $stringHorses
}
$positionHorses=0..9|% { 0 }
while (($positionHorses | Sort-Object | select -First 1) -lt 50)
{
    $positionHorses=0..9|% {$($positionHorses[$_])+ (get-random -Maximum 2)}
    $stringHorses=print-horses $positionHorses
    $origpos = $host.UI.RawUI.CursorPosition
    write-host ($stringHorses -join "`n")
    $host.UI.RawUI.CursorPosition=$origpos
}

write-host ($stringHorses -join "`n")
$winer=($stringHorses |sort-object -property length|select -last 1) -replace ":.*",""
write-host "Horse $winer winer!"


