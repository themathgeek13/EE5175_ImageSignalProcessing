function [s]=clip(val,M)
s=min(max(1,floor(val)),M);