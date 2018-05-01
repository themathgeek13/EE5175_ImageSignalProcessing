function [fhat,rms] = blur(f,g,h,n,sigb,sign,lambda)
    H = psf2otf(h,[277,277]);
    G = fft2(g);
    qx=[1 -1];
    Qx=psf2otf(qx,[277,277]);
    qy=qx';
    Qy=psf2otf(qy,[277,277]);
    
    Fhat=(conj(H).*G)./(H.*conj(H)+lambda*Qx.*conj(Qx)+lambda*Qy.*conj(Qy));
    fhat=ifft2(Fhat);
    %imshow([uint8(fhat),uint8(g)]);
    rms=(sum(sum((fhat-double(g)).^2)));
end