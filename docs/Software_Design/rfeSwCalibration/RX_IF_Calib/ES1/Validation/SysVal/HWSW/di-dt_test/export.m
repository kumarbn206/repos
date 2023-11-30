function export(folder_loc, png_image_name, template_path, result_ppt_name)

import mlreportgen.ppt.*
ppt=Presentation(strcat(folder_loc, '\', result_ppt_name), template_path);
open(ppt)


% Title . titleSlide = add(ppt,'Title Slide');
slide1=add(ppt,'Title Only')
% replace(slide1,'venu','Text Slide')
% replace(ppt,'Title 1','New Title Using Option 1')
% titleSlide = add(ppt,'Title Only');
% tb = TextBox();
% tb.X = '2in';
% tb.Y = '2in';
% tb.Width = '5in';
% % add(slide1,tb);
% 
% add(slide1,tb);

plane=Picture(strcat(folder_loc, '\', png_image_name));
plane.X='0in';
plane.Y='0.1in';
plane.Height='6.85in';
plane.Width='13.33in';
add(slide1,plane);
close(ppt)
end
