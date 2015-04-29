README - Tool for exposing digital forgeries by estimating light directions. Alexander Chocron, Nathan Immerman. 04/29/15.

1. Open the tool, and enter the image path as a command-line argument (type: gui 'image_path')

2. Draw the occluding boundaries at which you wish to determine the light direction. For best results, you may use the magnifying glass to zoom in on boundary locations before drawing. The drawings do not need to be perfect, but they should be quite close for best results. Also, the user should be careful to remain on the object and not draw on the background. To initiate the drawing tool, select "Add Boundary." This process must be repeated for each boundary you wish to add. There is no limit to the number of boundaries that can be drawn. 
3. Once you are done adding all desired boundaries, select "Finish Boundaries." In this phase of the tool, you must enter points that will be used to fit a quadric curve to fit to the boundaries that they user added. The GUI zooms in on small patches of a boundary, where you must select three points that might approximate the small patch. After each set of three points, select a point on the object itself. Once these four points are entered, the GUI zooms in on the next patch. This is repeated for all patches of all boundaries.

4. The GUI zooms out to reveal the entire boundary and you must select a point on the object where the arrow indicating the light direction will be plotted. This process repeats for each boundary that the user added.

5. You have the ability to view the entered boundaries and the estimated normal vectors by toggling the buttons"Toggle Boundaries" and "Toggle Normal Vectors" respectively. The boundary will be shown in red, and the normal vectors will be shown in green.

6. The angle (measured South of West) of each light direction will be printed to the command line.
