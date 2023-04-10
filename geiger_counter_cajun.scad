$fn=32;

board_z=1;
wall=2;
gap=0.2;

bat_x=99.2;
bat_y=29.5;
bat_z1=20;
bat_z2=7.5;
bat_con_usbc_x=10.1;
bat_con_usbc_z=3.6;
bat_con_usbc_off_x=18.5;
bat_con_usbc_off_y=bat_y;
bat_con_usbc_off_z=bat_z2-board_z-bat_con_usbc_z-0.2;
bat_con_button_x=3.5;
bat_con_button_z=2;
bat_con_button_off_x=85.5;
bat_con_button_off_y=bat_y;
bat_con_button_off_z=bat_z2+1.6;
bat_display_x=17;
bat_display_y=3.2;
bat_display_off_x=18.5;
bat_display_off_y=4.1;
bat_display_off_z=0;
bat_screw_dia=3.2;
bat_screw_off_x=3;
bat_screw_off_y=3;

conjun_x=108;
conjun_y=62.5;
conjun_z1=15;
conjun_z2=5;
conjun_con_audio_dia=6;
conjun_con_audio_off_x=conjun_x;
conjun_con_audio_off_y=47-conjun_con_audio_dia/2;
conjun_con_audio_off_z=conjun_z2+2.9-conjun_con_audio_dia/2;
conjun_con_power_dia=7;
conjun_con_power_off_x=0;
conjun_con_power_off_y=41-conjun_con_power_dia/2;
conjun_con_power_off_z=conjun_z2+6.5-conjun_con_power_dia/2;
conjun_switch_y=8;
conjun_switch_x=wall;
conjun_switch_z=3.5;
conjun_switch_off_x=0;
conjun_switch_off_y=25;
conjun_switch_off_z=conjun_z2-board_z+1.8;
conjun_screw_dia=3.2;
conjun_screw_off_x=2.8;
conjun_screw_off_y=2.8;

esp_y=25.5;
esp_x=34.5;
esp_z1=3;
esp_z2=4.7;
esp_con_usb_y=7.8;
esp_con_usb_z=3;
esp_con_usb_off_y=8.2;
esp_con_usb_off_x=esp_x;
esp_con_usb_off_z=0;

oled_board_x=27.2;
oled_board_y=27.2;
oled_board_z1=2.1;
oled_board_z2=2.3;
oled_board_screw_dia=2;
oled_board_screw_off_x=1.75;
oled_board_screw_off_y=1.75;

oled_display_x=27.2;
oled_display_y=19;
oled_display_z=2;
oled_display_off_y=4;
oled_display_off_x=0;

conjun_pad_x=conjun_screw_dia+conjun_screw_off_x+1;
conjun_pad_y=conjun_screw_dia+conjun_screw_off_y+1;

bat_pad_x=bat_screw_dia+bat_screw_off_x+1;
bat_pad_y=bat_screw_dia+bat_screw_off_y+1;

oled_board_pad_x=oled_board_screw_dia+oled_board_screw_off_x;
oled_board_pad_y=oled_board_screw_dia+oled_board_screw_off_y;

case_x=conjun_x + 2*gap + 2*wall;
case_y=conjun_y + bat_y + 3*gap + 2*wall;
case_z=bat_z1 + bat_z2 + 2*gap + 2*wall;

case_z2=wall+bat_z2+board_z+wall+1;
case_z1=case_z-case_z2;

tubecuts_x=case_x-10;
tubecut_num=20;
tubecut_x=tubecuts_x/tubecut_num/2;




//top();
bottom();



module bottom()
{
    difference()
    {
        union()
        {
            case_lower();
            place_bat() bat_pads();
            place_conjun() conjun_pads();
            case_connector();
        }
        place_conjun() conjun_screws();
        place_conjun() conjun_connections();
        place_bat() bat_screws();
        place_bat() bat_connections();
    }
}

module top()
{
    difference()
    {
        union()
        {
            case_upper();
            place_oled() oled_board_pads();
            place_esp() holder(esp_x,esp_y,esp_z1,esp_z2,board_z,wall,gap,1);
        }
        place_oled() oled_display_opening();
        place_oled() oled_board_screws();
        place_esp() esp_connections();
        place_bat() bat_connections();
        place_conjun() conjun_connections();
        tubecut();
    }
}

/////////////////
// ESP modules //
/////////////////

module place_esp()
{
    translate([case_x-esp_x-wall+1-gap,
               wall+10,
               case_z-wall-esp_z1-esp_z2])
    {
        children();
    }
}

module esp_connections()
{
    translate([esp_con_usb_off_x-1,esp_con_usb_off_y,esp_con_usb_off_z])
    {
        cube([1+2*wall+2*gap,esp_con_usb_y,esp_con_usb_z]);
    }
}


//////////////////
// Oled modules //
//////////////////

module place_oled()
{
    translate([wall+20,
               wall+20,
               case_z-wall-oled_board_z1-oled_board_z2])
    {
        #children();
    }
}

module oled_board_pads()
{
    translate([0,0,oled_board_z2])
    {
        difference()
        {
            cube([oled_board_x,oled_board_y,oled_board_z1]);
            cross(oled_board_x,oled_board_y,oled_board_z1,oled_board_pad_x,oled_board_pad_y);
        }
    }
}

module oled_board_screws()
{
    translate([0,0,-gap-wall])
    {
        screws(oled_board_x,
               oled_board_y,
               oled_board_screw_off_x,
               oled_board_screw_off_y,
               oled_board_screw_dia,
               wall+gap+oled_board_z1);
    }
}

module oled_display_opening()
{
    translate([oled_display_off_x,oled_display_off_y,oled_board_z1+oled_board_z2])
    {
        hull()
        {
            cube([oled_display_x,oled_display_y,gap+wall]);
            translate([-wall/2,-wall/2,wall])
            {
                cube([oled_display_x+wall,oled_display_y+wall,gap]);
            }
        }
    }
}

////////////////////
// Conjun modules //
////////////////////
module place_conjun(){
    translate([wall+gap,wall+gap,wall])
    {
        children();
    }
}

module conjun_pads()
{
    difference()
    {
        cube([conjun_x,conjun_y,conjun_z2-board_z]);
        cross(conjun_x,conjun_y,conjun_z2-board_z,conjun_pad_x,conjun_pad_y);
    }
}

module conjun_screws()
{
    translate([0,0,-gap-wall])
    {
        screws(conjun_x,
               conjun_y,
               conjun_screw_off_x,
               conjun_screw_off_y,
               conjun_screw_dia,
               wall+gap+conjun_z2-board_z);
    }
}

module conjun_connections()
{
    translate([conjun_switch_off_x-conjun_switch_x-gap,
               conjun_switch_off_y,
               conjun_switch_off_z])
    {
        cube([conjun_switch_x,conjun_switch_y,conjun_switch_z]);
    }

    translate([conjun_con_audio_off_x+gap,
               conjun_con_audio_off_y,
               conjun_con_audio_off_z])
    {
        translate([0,conjun_con_audio_dia/2,conjun_con_audio_dia/2])
        {
            rotate([0,90,0])
            {
                cylinder(h=wall,d=conjun_con_audio_dia);
            }
        }
    }

    translate([conjun_con_power_off_x-wall-gap,
               conjun_con_power_off_y,
               conjun_con_power_off_z])
    {
        translate([0,conjun_con_power_dia/2,conjun_con_power_dia/2])
        {
            rotate([0,90,0])
            {
                cylinder(h=wall,d=conjun_con_power_dia);
            }
        }
    }
}


/////////////////////
// Battery modules //
/////////////////////

module place_bat(){
    translate([wall+gap,wall+2*gap+conjun_y,wall])
    {
        children();
    }
}

module bat_pads()
{
    difference()
    {
        cube([bat_x,bat_y,bat_z2-board_z]);
        cross(bat_x,bat_y,bat_z2-board_z,bat_pad_x,bat_pad_y);
    }
}

module bat_screws()
{
    translate([0,0,-gap-wall])
    {
        screws(bat_x,
               bat_y,
               bat_screw_off_x,
               bat_screw_off_y,
               bat_screw_dia,
               wall+gap+bat_z2-board_z);
    }
}

module bat_connections()
{
    translate([bat_con_usbc_off_x,bat_con_usbc_off_y+gap,bat_con_usbc_off_z])
    {
        cube([bat_con_usbc_x,wall,bat_con_usbc_z]);
    }

    translate([bat_con_button_off_x,bat_con_button_off_y+gap,bat_con_button_off_z])
    {
        cube([bat_con_button_x,wall,bat_con_button_z]);
    }
    translate([bat_display_off_x,bat_display_off_y,bat_display_off_z-wall])
    {
        cube([bat_display_x,bat_display_y,wall]);
    }
}


//////////////////
// Case modules //
//////////////////

module case_upper()
{
    intersection()
    {
        case();
        translate([0,0,case_z2])
        {
            cube([case_x,case_y,case_z1]);
        }
    }
}

module case_lower()
{
    intersection()
    {
        case();
        cube([case_x,case_y,case_z2]);
    }
}

module case()
{
    difference()
    {
        case_frame([case_x,case_y,case_z]);
        translate([wall,wall,wall])
        {
            case_frame([case_x,case_y,case_z]-2*[wall,wall,wall]);
            cube([case_x,case_y,conjun_z1+conjun_z2+board_z]-2*[wall,wall,wall]);
        }
    }
}

module tubecut()
{
    translate([7.5,0,case_z2+2*wall])
    {
        for(i=[0:tubecut_x:tubecuts_x/2-tubecut_x])
        {
            translate([2*i,0,0])
            {
                #cube([tubecut_x,10,case_z1]);
            }
        }
    }
}

module case_connector()
{
    translate([1.5*wall,wall,case_z2-wall])
    {
        difference()
        {
            cube([case_x-4*wall+2*gap,
                  case_y-2*wall,
                  2*wall]);
            translate([0,wall/2,0])
            {
                cube([case_x-3*wall+gap,
                      case_y-3*wall,
                      2*wall]);
            }
            translate([20,0,0])
            {
                #cube([case_x-40,
                      case_y-2*wall,
                      2*wall]);
            }
        }
    }

    translate([wall,2*wall,case_z2-wall])
    {
        difference()
        {
            cube([case_x-2*wall,
                  case_y-4*wall,
                  2*wall]);
            translate([0,20-2*wall,0])
            {
                #cube([case_x-2*wall+2*gap,
                      case_y-40,
                      2*wall]);
            }
            translate([wall/2,0,0])
            {
                cube([case_x-3*wall,
                      case_y-3*wall,
                      2*wall]);
            }
        }
    }
}

/////////////////////
// General modules //
/////////////////////

module screws(x,y,off_x,off_y,dia,height)
{
    translate([off_x,off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=wall,d=1.8*dia,$fn=6);
    }
    translate([off_x,y-off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=wall,d=1.8*dia,$fn=6);
    }
    translate([x-off_x,y-off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=wall,d=1.8*dia,$fn=6);
    }
    translate([x-off_x,off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=wall,d=1.8*dia,$fn=6);
    }
}

module holder(x,y,z1,z2,board_z,wall,gap,cutout)
{
    difference()
    {
        translate([0,-wall,0])
        {
            cube([x-cutout+wall+gap,
                  y+2*wall+2*gap,
                  z1+z2]);
        }
        translate([0,cutout/2,0]){
            #cube([x-cutout,y-cutout,z1]);
        }
        translate([0,0,z1]){
            #cube([x,y,board_z]);
        }
        translate([0,cutout/2,z1+board_z]){
            cube([x-cutout,y-cutout,z2]);
        }
    }
}

module case_frame(dim)
{
    intersection()
    {
        cube_round(dim);
        translate([0,0,-15/2+2])
        {
            cube_round(dim+[0,0,15/2-2],mki=15,plane="yz");
        }
    }
}

module cross(x,y,z,cut_x,cut_y)
{
    translate([cut_x,0,0])
        {
            cube([x-2*cut_x,y,z]);
        }
        translate([0,cut_y,0])
        {
            cube([x,y-2*cut_y,z]);
        }
}

module cube_round(dim,mki=5,plane="xy"){
    if(mki<=0)
    {
        cube(dim);
    }
    else
    {
        if(plane=="xy")
        {
            translate([mki/2,mki/2,0])
            {
                linear_extrude(dim[2])
                {
                    minkowski()
                    {
                        square([dim[0]-mki,dim[1]-mki]);
                        circle(d=mki);
                    }
                }
            }
        }
        if(plane=="yz")
        {
            translate([0,mki/2,dim[2]-mki/2])
            {
                rotate([0,90,0])
                {
                    linear_extrude(dim[0])
                    {
                        minkowski()
                        {
                            square([dim[2]-mki,dim[1]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
        if(plane=="xz")
        {
            translate([mki/2,dim[1],mki/2])
            {
                rotate([90,0,0])
                {
                    linear_extrude(dim[1])
                    {
                        minkowski()
                        {
                            square([dim[0]-mki,dim[2]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
    }
}

