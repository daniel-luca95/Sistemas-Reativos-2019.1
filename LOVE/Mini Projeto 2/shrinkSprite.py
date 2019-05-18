from PIL import Image

# im = Image.open("C:\\Users\\danielluca\\Documents\\Sistemas-Reativos-2019.1\\LOVE\\Mini Projeto 2\\attackfeedback.png")
#
# l = 20
# im.putalpha(255)
#
# def alphaValue(xl, yl):
#     xl = float(xl)/l
#     yl = float(yl)/l
#     return max( -(xl-2.0/3)**2/2.0 - (1.4*yl-0.5)**2/2.0 + 1.0 , 0.0) * 125
#
# for y in range(l):
#     for x in range(l):
#         pixel = im.getpixel((x,y))
#         print (tuple([ pixel[0], pixel[1], pixel[2], int(alphaValue(x, y))]))
#         if pixel == (255, 255, 255, 255):
#             im.putpixel((x,y), (255,255,255,0))
#         else:
#             im.putpixel((x,y), (pixel[0], pixel[1], pixel[2], int(alphaValue(x+0.5, y+0.5))))
#
#
# im.save("C:\\Users\\danielluca\\Documents\\Sistemas-Reativos-2019.1\\LOVE\\Mini Projeto 2\\attackfeedbackcorrected.png")


# green = ()
#
# im = Image.open("C:\\Users\\danielluca\\Documents\\Sistemas-Reativos-2019.1\\LOVE\\Mini Projeto 2\\troll.png")
#
# firstX = im.width
# firstY = im.height
# lastX = 0
# lastY = 0
# for x in range(im.width):
#     for y in range(im.height):
#         if im.getpixel((x,y))[3] > 0:
#             firstX = min(firstX, x)
#             firstY = min(firstY, y)
#             lastX = max(lastX, x)
#             lastY = max(lastY, y)
#
# final = Image.new("RGBA", (lastX - firstX + 1, lastY - firstY + 1))
# for x in range(final.width):
#     for y in range(final.height):
#         final.putpixel((x,y), im.getpixel((x+firstX, y+firstY)))
#
#
# final.save("C:\\Users\\danielluca\\Documents\\Sistemas-Reativos-2019.1\\LOVE\\Mini Projeto 2\\trollcorrected.png")



