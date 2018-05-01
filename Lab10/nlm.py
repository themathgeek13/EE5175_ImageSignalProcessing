import cv2
import numpy as np
from pylab import *

g=cv2.imread("krishna_0_001.png")
f=cv2.imread("krishna.png")

g=np.array(g)
f=np.array(f)

f_hat=np.zeros(f.shape)

g=g/255.0
f=f/255.0

w,h,c=g.shape
wvals=[]
def show(img):
    cv2.imshow("image",img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def NLM(Wsim,W,sigNLM,g):

    g=np.pad(g,((Wsim+W,Wsim+W),(Wsim+W,Wsim+W),(0,0)),'constant')
    print g.shape
    for i in range(Wsim+W,w+Wsim+W):
        for j in range(Wsim+W,h+Wsim+W):
            Np = g[i-Wsim:i+Wsim+1,j-Wsim:j+Wsim+1,:]
            Vp = Np.flatten()

            wp=np.zeros((2*W+1,2*W+1))
            
            for k in range(-W,W+1):
                for l in range(-W,W+1):
                    Nq=g[i+k-Wsim:i+k+Wsim+1,j+l-Wsim:j+l+Wsim+1,:]
                    Vq=Nq.flatten()
                    wp[k+W,l+W] = np.exp(-np.dot(Vp-Vq,Vp-Vq)/(sigNLM*sigNLM))

            wp=wp/sum(sum(wp))
            if((i==63+Wsim+W)):
                if((j==93+Wsim+W)):
                    print wp.shape
	            print wp[:,5]
		    plt.imshow(wp,interpolation='None')
		    plt.show()
		    #show(g[i-10*W:i+10*W+1,j-10*W:j+10*W+1])
		    #plt.show()
            wp=wp.flatten()

            NpWR = g[i-W:i+W+1,j-W:j+W+1,0]
            VpWR = NpWR.flatten()

            NpWG = g[i-W:i+W+1,j-W:j+W+1,1]
            VpWG = NpWG.flatten()

            NpWB = g[i-W:i+W+1,j-W:j+W+1,2]
            VpWB = NpWB.flatten()

            f_hat[i-Wsim-W,j-Wsim-W,0]=np.dot(VpWR,wp);
            f_hat[i-Wsim-W,j-Wsim-W,1]=np.dot(VpWG,wp);
            f_hat[i-Wsim-W,j-Wsim-W,2]=np.dot(VpWB,wp);

    #g=cv2.imread("krishna_0_001.png")
    #g=np.array(g)/255.0

    MSE=np.dot((f-f_hat).flatten(),(f-f_hat).flatten())

    PSNR=10*np.log10(1/MSE)

    print MSE,PSNR

    show(f_hat)
    return f_hat, MSE, PSNR

g=cv2.imread("krishna_0_001.png")
g=np.array(g)/255.0
baselineMSE=np.dot((f-g).flatten(),(f-g).flatten())
baselinePSNR=10*np.log10(1/baselineMSE)

Wsim=3; W=5; sigNLM=0.1;

msevals=[]
psnrvals=[]

for sigNLM in range(5,11):
    f_hat,MSE,PSNR=NLM(Wsim,W,sigNLM/10.0,g)
    msevals.append(MSE)
    psnrvals.append(PSNR)

msevals2=[]
psnrvals2=[]

W=10
for sigNLM in range(5,11):
    f_hat,MSE,PSNR=NLM(Wsim,W,sigNLM/10.0,g)
    msevals2.append(MSE)
    psnrvals2.append(PSNR)

msevals3=[]
psnrvals3=[]

for s in range(1,11):
    sigma=s/10.0
    t=4.5/sigma           
    f_hat=scipy.ndimage.filters.gaussian_filter(g,sigma,truncate=t)
    MSE=np.dot((f-f_hat).flatten(),(f-f_hat).flatten())
    PSNR=10*np.log10(1/MSE)
    msevals3.append(MSE)
    psnrvals3.append(PSNR)

def plots():
    plot(np.array(range(1,11))/10.0,[baselinePSNR]*10)
    plot(np.array(range(1,11))/10.0,psnrvals)
    plot(np.array(range(1,11))/10.0,psnrvals2)
    plot(np.array(range(1,11))/10.0,psnrvals3)
    plot(np.array(range(1,11))/10.0,psnrvals,'go')
    plot(np.array(range(1,11))/10.0,psnrvals2,'ro')
    plot(np.array(range(1,11))/10.0,psnrvals3,'bo')
    xlabel(u'$\sigma_{NLM}$')
    ylabel("PSNR")
    title(u'Plot of PSNR v/s $\sigma_{NLM}$')
    legend(['baseline','W=5,Wsim=3','W=10,Wsim=3','Gaussian filter'])

from scipy import signal
def gkern(kernlen=21, std=3):
    """Returns a 2D Gaussian kernel array."""
    gkern1d = signal.gaussian(kernlen, std=std).reshape(kernlen, 1)
    gkern2d = np.outer(gkern1d, gkern1d)
    return gkern2d

plt.imshow(gkern(11,0.1),interpolation='None')
plt.show()
