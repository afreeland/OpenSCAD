// OpenSCAD Project: Dome Casting

// Number of rows
_rows = 4;

// Number of columns
_cols = 3;

// Padding in between each dome
_padding = 15;

/* [Hidden] */
// Parameters
$fn = 100; // [100] OpenSCAD resolution

// Diameter of dome mold
diam = 20; // [20:20]

// Height of dome mold
height = 10; // [10:10]

// How thick do we want our tray
thickness = 2; // [2]

module Make_Tray(){
    // Find out how large one cell is that contains a dome
    cellSize = Calculate_Cell();

    // Use our cell size * the number of columns
    columnLength = cellSize * _cols;

    echo("ColumnLength:", columnLength);

    // Find mid-point for column width
    midpoint_width = ((columnLength / 2) + cellSize/2);
   
   
    // Iterate through each of our columns that need a dome
    for(i = [0:_cols - 1]){
        // Determine our current coordinates
        // ((columnLength / 2) + cellSize/2) - Gives us 
        coord_x = midpoint_width - ( ( i + 1 ) * cellSize );
        
        // Use this method to begin building an entire column
        Make_Column(coord_x);
    }
}

/**
 * @param [number] x - X-Coordinate of where this column will rendered
 */
module Make_Column(x){
    // Find out how large one cell is that contains a dome
    cellSize = Calculate_Cell();

    // Get the total length of our rows
    rowLength = cellSize * _rows;

    echo("RowLength: ", rowLength);

    // Find mid point for column length (# of rows)
    midpointheight = ( (rowLength/2) + cellSize/2);

    // Determine whe
    coord_y = 0;

    for(z = [0:_rows -1]){
        coord_y = midpointheight - ( (z+1) * cellSize);
        Draw_Dome(x, coord_y);
    }

    
}

module Draw_Dome(x, y){
   

    // Find out how large one cell is that contains a dome
    cellSize = Calculate_Cell();

    // Get radius
    r = diam/2;

    sphereRadius = ( pow(height,2) + pow(r,2) ) / (2*height);

    
    translate([x, y, 0])
        difference(){
            cube([cellSize, cellSize, thickness], center=true);
            sphere(sphereRadius);
        }

    

    translate([x, y, -3])
        difference(){

            // The thick layer (shell) that encases the desired casting mold (20mm x 10mm)
            shell = sphereRadius + thickness;
            
            sphere(shell);
            // // Build Sphere
            sphere(sphereRadius);
            
            cr = 2*shell;
            // // Remove the bottom half of sphere with cube
             translate([0,0,-height])
                cube([cr, cr, cr], center=true);
   }

}

// Simply returns back how big a cell is going to be
function Calculate_Cell() = (diam + _padding );

Make_Tray();