function rerendered = render_img( normal, albedo, mask_obj )

imgMask = rgb2gray(imread(mask_obj));

L = [0; 0; 1];

% find all object's pixels
[objectY objectX] = find(imgMask > 127);

%alloc
rerendered = zeros(length(imgMask(:,1)),length(imgMask(1,:)));

for i=1:length(objectX(:))	% iterate all X Y of object
	X_idx = objectX(i);
	Y_idx = objectY(i);
	
	rerendered(Y_idx,X_idx) = albedo(Y_idx,X_idx).*dot(reshape(normal(Y_idx,X_idx,:),3,1),L);
end
% rerendered = abs(rerendered);
min_rerendered = min(min(rerendered));
rerendered = abs(rerendered ./ min_rerendered);
end

