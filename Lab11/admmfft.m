function iml = admmfft(b,k,mu,ispadding)
    % iml - latent image
    % b - blurred image
    % k - kernal image
    % mu - weight of gradient sparsity prior
    [h,w,~] = size(b);
    b0 = b;
    
    % make sure that b has odd height and width. padding is necessary to
    % avoid boundary effect
    if ~ispadding
        if mod(h,2)==0
            b = b(1:h-1,:);
        end
        if mod(w,2)==0
            b = b(:,1:w-1);
        end
    else
        b11 = b;
        b12 = fliplr(b);
        b21 = flipud(b);
        b22 = rot90(b,2);
        b = [b11 b12(:,2:w);
            b21(2:h,:) b22(2:h,2:w)];
    end
    
    %% derivative kernel
    Dx = [0 0 0; -1 1 0; 0 0 0];
    Dy = Dx';
    % Dxt = rot90(Dx,2);
    % Dyt = rot90(Dy,2);

    %% prox Huber
    Amplitude = @(u)sqrt(u.^2);
    ProxH = @(u,s,eps) u - 1/s * (s*u./(1 + eps * s)) ./ max(1, Amplitude(s*u./(1 + eps * s)));
    
    %% to solve:  1/2 ||b-kl||_2^2 + mu ||Dl||_H
    % l = argmin( 1/2mu ||b-Pl||_2^2 + rho/2 ||Dl-s+u||_2^2 )
    % d = argmin(     ||s||_1       + rho/2 ||Dl-s+u||_2^2 )
    % u = u + Dl - s
    l = b;
    s = zeros(size(b,1),2*size(b,2));
    u = s;
    rho = 5;
    for iter = 1:20
        % l-subprob: Fourier Division
        lold = l;
        
        EP = padarray(k,[floor((size(b,1)-size(k,1))/2) floor((size(b,2)-size(k,2))/2)],'both');
        EDx = padarray(Dx,[floor((size(b,1)-size(Dx,1))/2) floor((size(b,2)-size(Dx,2))/2)],'both');
        EDy = padarray(Dy,[floor((size(b,1)-size(Dy,1))/2) floor((size(b,2)-size(Dy,2))/2)],'both');
        denominator =  1/mu*conj(fft2(EP)).*fft2(EP) + rho*( conj(fft2(EDx)).*fft2(EDx) + conj(fft2(EDy)).*fft2(EDy) );

        sux = s(:,1:size(b,2))-u(:,1:size(b,2));
        suy = s(:,size(b,2)+1:2*size(b,2))-u(:,size(b,2)+1:2*size(b,2));
        numerator = 1/mu*conj(fft2(EP)).*fft2(b) + rho*( conj(fft2(EDx)).*fft2(sux) + conj(fft2(EDy)).*fft2(suy) );

        l = fftshift((ifft2(numerator./denominator)));

        % s-subprob: shrink: PASSED
        Dlu = [convm(l,Dx) convm(l,Dy)] + u;
        s(:) = ProxH( Dlu(:), rho, 0 );

        % update u
        u = Dlu - s;
        
        if norm(lold-l) < 1e-4 %sqrt(sum(sum(b.*b)))/1000
            break;
        end

    end
    if ~ispadding
        iml = b0;
        iml(1:size(l,1), 1:size(l,2)) = l;
    else
        iml = l(1:h,1:w);
    end
    
end


function ret = convm(i,k)
    ret = imfilter(i,k,'conv');
end


