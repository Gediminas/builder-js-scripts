<?php
function CheckAddProject_vcxproj($prj, $configs, $platform, $commands_txt) {
	$content = file_get_contents($prj);
	foreach ($configs as $config) {
		$needle="<ProjectConfiguration Include=\"$config|$platform\">";
		if( strpos($content, $needle) !== false) {
			$file = fopen($commands_txt, 'a');
			$line = "$prj|$config|$platform\n";
			fwrite($file, $line);
			fclose($file);
		}
	}
}

function CollectProjectsRecursive($build_cfg, $configurations, $platform, $commands_txt) {
	$root  = pathinfo($build_cfg, PATHINFO_DIRNAME);
	$paths = file($build_cfg, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	foreach ($paths as $i => $path) {
	    $path = trim($path);
		$path = "$root/$path";
		$path = str_replace("\\", "/", "$path"); //common style
	    $realpath = realpath($path);
        if (!is_file($realpath)) {
			echo "ERROR: '$path' file not found\n";
			continue;
		}
		$ext = pathinfo($realpath, PATHINFO_EXTENSION);
		if ($ext === 'cfg') {
			CollectProjectsRecursive($realpath, $configurations, $platform, $commands_txt);
		}
		else if ($ext === 'vcxproj') {
			CheckAddProject_vcxproj($realpath, $configurations, $platform, $commands_txt);
		}
		else {
			echo "ERROR: Unknown project type '$realpath'";
		}
	}
}

$root_build_cfg = $argv[1];
$configs        = explode(',', $argv[2]);
$platform       = $argv[3];
$out            = $argv[4];

$root_build_cfg = realpath($root_build_cfg);

if (!is_file($root_build_cfg)) {
	echo "ERROR: '$root_build_cfg' root cfg file not found\n";
	return;
}

unlink("$out");
CollectProjectsRecursive($root_build_cfg, $configs, $platform, $out);
?>
