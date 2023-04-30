<?php

define('TARGET_PREF_IDS', [
  11, // 埼玉県
  12, // 千葉県
  13, // 東京都
  14, // 神奈川県
]);

$buf = file_get_contents(dirname(__FILE__).'/station20230327free.csv');

$results = explode("\n", $buf);
array_shift($results);
$stations = [];
$xArray = [];
$yArray = [];

foreach ($results as $r) {
  $rArray = explode(',', $r);
  if (count($rArray) <= 1) continue;

  $code = $rArray[1];
  $pref = $rArray[6];
  $name = $rArray[2];
  $x    = floatval($rArray[9]);
  $y    = floatval($rArray[10]);

  if (!in_array($pref, TARGET_PREF_IDS)) continue;
  if ($name != '新松戸') continue;
  $xArray[] = $x;
  $yArray[] = $y;

  $stations[$code] = [
    'name' => $name,
    'x'    => $x,
    'y'    => $y,
  ];
}

//$xMin = min($xArray);
$xMin = 138.691406;
//$xMax = max($xArray);
$xMax = 140.894165;
// $yMin = min($yArray);
$yMin = 34.894942;
// $yMax = max($yArray);
$yMax = 36.290777;

echo "x: {$xMin} - {$xMax}\n";
echo "y: {$yMin} - {$yMax}\n";

foreach ($stations as $code => $v) {
  $stations[$code]['x'] = ($stations[$code]['x'] - $xMin) / ($xMax - $xMin);
  $stations[$code]['y'] = 1 - (($stations[$code]['y'] - $yMin) / ($yMax - $yMin));
}

$stasJson = 'var STATIONS = '.json_encode(array_values($stations), JSON_UNESCAPED_UNICODE).';';

file_put_contents(dirname(__FILE__).'/../js/stations.js', $stasJson);
