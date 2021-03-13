#!/usr/bin/env bash

check_dep() {
    distr_bin_path="$1";
    preserves="$2";
    WARE="${BASH_SOURCE%[/\\]*}"

    distr_bin_path=$(realpath --no-symlinks "$distr_bin_path")
    echo "$distr_bin_path"
    echo "$preserves"

    distr_bin_path="d:\dev\repo\builder\_scripts\_working\wood\work_debug\distr\bin"
	exe="$distr_bin_path/*.exe"
	dll="$distr_bin_path/*.dll"
    dep_txt="$WORK/dependencies.txt"

	dumpbin //DEPENDENTS "$exe" "$dll" 1>"$dep_txt"
    removes=$(php "$WARE"/php/analyze_dependencies.php "$dep_txt" "$preserves" 1)

    echo -e "~ removes=\n$removes"

    # //echo "check dir: [$distr_bin_path*]\n";
    # $removes     = dependList($command_log, $worker_id, "$distr_bin_path", "$preserves", 1);
    # $remove_list = explode(";", $removes);

    # // Remove unused binaries

    # foreach ($remove_list as $file_name) if (strlen($file_name)>1)
    # {
    # 	$file_path = "$distr_bin_path/$file_name";
    # 	unlink("$file_path");
    # 	_log_to($command_log, "Removing dependency: [$file_path]");
    # }

    # // Cheking preserve list";
    # checkDependList($command_log, $distr_bin_path, $preserves);

    # // Cheking dll's in pakage
    # // There are missing:";

    # $missing = dependList($command_log, $worker_id, "$distr_bin_path", "$preserves", 3); // type3 shows missing dll's
    # if (strlen($missing) > 4)
    # 	_log_to($command_log, "WARNING: Some files missing [$missing]");
}
