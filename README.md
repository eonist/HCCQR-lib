# HCCQR-demo
High capacity quick response code

### Todo:
1. Add 4 CGLayer Squares to a view, R,G,B,W (black background) 👈
2. Find color channel splitting code on the internet
3. Try to extract R,G,B
4. Find invert color code on the internet
5. Find blend image (where white is transperant) code on the internet
6. Find UIImage method that can get image from view-content on the internet
7. Try darker and lighter R,G,B,W colors. And see if they are still splittable
8. write a QR-Parser that scans a QR grid, and record each block in a 2d-Grid based on Black/white
9. get 2d array for 2 strings
10. write a QR-Writer that based on the combined block in the two "2d-arrays" make up a block of R,G,B,W
11. write the QR-Reader that splits an image into color channels, then recombines them to make up 2 unique QR-Frames
12. Test creating HCCQR, Test Reading HCCQR
13. Test reading and writing in real world conditions. Mobile scan Mac-screen
