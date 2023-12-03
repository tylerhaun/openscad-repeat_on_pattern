

module repeat_on_circle(
    radius,
    num_instances,
    angle_offset = 0,
    include_last = false,
) {

    repeat_on_ellipse(
        semi_major_axis = radius,
        semi_minor_axis = radius,
        num_instances = num_instances,
        angle_offset = angle_offset,
        include_last = include_last,
    )
        children();

//    for (j = [0:num_instances - (include_last ? 0 : 1)]) {
//        angle = (j * 360 / num_instances) + angle_offset;
//        translate([radius * cos(angle), radius * sin(angle)])
//        rotate([0, 0, angle])
//        children();
//    }
}

module repeat_on_line(
    length,
    num_instances,
    offset = 0,
    odd_offset = 0,
    center=false,
) {

    for (i = [0:num_instances-1]) {
        position_offset =
            (i * length / (num_instances-1))
            + offset
            + (center ? -length/2 : 0)
            + (i%2 == 1 ? odd_offset : 0)
        ;
        translate([position_offset,0,0])
        children();
    }
    
}

module repeat_on_rectangle(
    x_length,
    y_length,
    x_num_instances,
    y_num_instances,
    x_offset = 0,
    y_offset = 0,
    x_odd_offset=0,
    y_odd_offset=0,
    row_offset=0,
    center=false,
) {
    
    for (i = [0:y_num_instances-1]) {
        position_offset = (i * y_length / (y_num_instances-1))
            + y_offset
            + (center ? -y_length/2 : 0)
            + (i%2 == 1 ? y_odd_offset : 0)
        ;
        
        translate([0,position_offset,0])
        repeat_on_line(
            length=x_length,
            num_instances=x_num_instances,
            offset = x_offset + (i%2 == 1 ? row_offset : 0),
            odd_offset = x_odd_offset 
,
            center=center
        )
        children();
    }

}

module repeat_on_cylinder(
    radius,
    height,
    num_circumference,
    num_height,
    row_offset = 0,
) {
  for (i = [0:num_height]) {
      
    z_offset = i * height / num_height;

    translate([0,0,z_offset])
    repeat_on_circle(
        radius=radius,
        num_instances=num_circumference,
        angle_offset=row_offset * i,
        include_last=false,
    )
        children();
  }
}


module repeat_on_ellipse(
    semi_major_axis,
    semi_minor_axis,
    num_instances,
    angle_offset = 0,
    include_last = false,
) {


    for (j = [0:num_instances - (include_last ? 0 : 1)]) {
        angle = (j * 360 / num_instances) + angle_offset;
        translate([
            semi_major_axis * cos(angle),
            semi_minor_axis * sin(angle)
        ])
        rotate([0, 0, angle])
            children();
    }

}



module test() {

    translate([0,0])
    repeat_on_circle(
        radius=2,
        num_instances=8,
        angle_offset=20
    )
        circle(0.4);


    translate([10,0])
    repeat_on_ellipse(
        semi_major_axis=2.5,
        semi_minor_axis=1.5,
        num_instances=8,
        angle_offset=10,
        include_last=false
    )
        circle(0.4);

    translate([20,0])
    repeat_on_line(
        length=6,
        num_instances=5,
        offset=.3,
        odd_offset=.4,
        center=true
    )
        circle(0.4);

    translate([30,0])
    repeat_on_rectangle(
        x_length=7,
        y_length=5,
        x_num_instances=5,
        y_num_instances=6,
        x_offset=0.6,
        y_offset=1,
        x_odd_offset=0.1,
        y_odd_offset=.2,
        row_offset=-.5,
        center=true
    )
        circle(0.3);
        
    translate([40, 0])
    repeat_on_cylinder(
        radius=4,
        height=5,
        num_circumference=7,
        num_height=3,
        row_offset=10,
    )
        circle(0.3);
    

}
test();
