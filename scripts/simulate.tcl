proc run_simulation {project_name top_module tb_module} {

    file delete -force $project_name.xpr *.os *.jou *.log $project_name.srcs $project_name.cache $project_name.runs

    set part xc7a35tcpg236-1  ;# Basys3

    set src_dir ./src
    set tb_dir ./tests
    set sim_dir ./sim

    create_project $project_name -part $part -force

    if {[glob -nocomplain $src_dir/*.sv] != ""} {
        puts "Reading SV files..."
        add_files -fileset sources_1 [glob $src_dir/*.sv]
    }
    if {[glob -nocomplain $src_dir/*.v] != ""} {
        puts "Reading Verilog files..."
        add_files -fileset sources_1 [glob $src_dir/*.v]
    }

    set_property top $top_module [current_fileset]

    if {[glob -nocomplain $tb_dir/*.sv] != ""} {
        puts "Reading SV files..."
        add_files -fileset sim_1 [glob $tb_dir/*.sv]
    }
    if {[glob -nocomplain $tb_dir/*.v] != ""} {
        puts "Reading Verilog files..."
        add_files -fileset sim_1 [glob $tb_dir/*.v]
    }

    set_property top $tb_module [get_filesets sim_1]
    launch_simulation

    save_wave_config $sim_dir/$project_name.wcfg
    start_gui

# Optional: export waveform config layout
# write_wave_config $sim_dir/my_wave.wcfg

}