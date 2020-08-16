# $XMLPath = 'triangle.svg';
$XMLPath = 'snow-flake.svg';
$xml = [xml](Get-Content $XMLPath)

$points = $($xml.svg.polygon | Select-Object points).points.Split(' ');

$newPoints = New-Object System.Collections.Generic.List[System.Object]

for ($i = 0; $i -lt $points.Count; $i++) {
    $pointA = $points[$i].Split(',');
    $pointB = $points[($i + 1) % $points.Count].Split(',');

    $newPoints.Add($points[$i]);
    $newPoints.Add("$(($pointB[0] - $pointA[0]) / 3 + $pointA[0]),$(($pointB[1] - $pointA[1]) / 3 + $pointA[1])");

    $middlePoint = @($(($pointB[0] - $pointA[0]) / 2 + $pointA[0]), $(($pointB[1] - $pointA[1]) / 2 + $pointA[1]));
    $topPoint = @($($middlePoint[0] + ($pointB[1] - $middlePoint[1]) / 3 * 2 * [math]::Sqrt(0.75)), $($middlePoint[1] - ($pointB[0] - $middlePoint[0]) / 3 * 2 * [math]::Sqrt(0.75)));

    $newPoints.Add("$($topPoint[0]),$($topPoint[1])");
    $newPoints.Add("$(($pointB[0] - $pointA[0]) / 3 * 2 + $pointA[0]),$(($pointB[1] - $pointA[1]) / 3 * 2 + $pointA[1])");
}

$newpoints = $newpoints.ToArray();
for ($i = 0; $i -lt $newpoints.Count; $i++) {
    $pointA = $newpoints[$i].Split(',');
    $pointB = $newpoints[($i + 1) % $newpoints.Count].Split(',');
}

$xml.svg.polygon | ForEach-Object {$_.points = "$($newpoints -join ' ')"}

$xml.Save("snow-flake.svg");