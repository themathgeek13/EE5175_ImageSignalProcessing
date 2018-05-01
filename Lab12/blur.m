function [fhat,rms] = blur(f,g,h,lambda)
    H = psf2otf(h,[277,277]);
    G = fft2(g);
    
    Fhat=(conj(H).*G)./(H.*conj(H)+lambda);
    fhat=ifft2(Fhat);
    %imshow([uint8(fhat),uint8(g)]);
    rms=(sum(sum((fhat-double(f)).^2)));
end