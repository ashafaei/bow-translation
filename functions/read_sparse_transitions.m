function [ transitions ] = read_sparse_transitions(path, btheta, dphi)
% READ_SPARSE_TRANSITIONS Load sparse transition matrices to memory.
%
% Input:
%  path       : path of the folder with all the tranisition mat files.
%  btheta     : 1 x num_theta. Source theta locations, e.g., [30 60 90].
%  dpphi      : 1 x num_Phi  . Target phi locations, e.g., [0 60....300]
%
% Output:
%  tranistions: (num_files x 2) Cell array. First, column is the transitions
%               matrix. Second column is the file name.
%
% The file name protocol is as follows
% b.30(p.90.t.-30) means from the base view with elevation 30,
% we jump 90 degress to the right (azimuthal) and 30 degrees down(elevation).
% ----
% Ankur & Alireza

theta_trans = btheta;

file_count = numel(btheta)*numel(theta_trans)*numel(dphi);
files = cell(1, file_count) ;
    
ind = 0;
for th_i = btheta    
    for th_j = theta_trans
       for p_i = dphi
          ind = ind + 1;
          files{ind} = sprintf('b.%d(p.%d.t.%d).mat', th_i, ...
                     p_i, th_j - th_i);               
    
       end
    end
end
transitions = cell(file_count, 2);
ind = 0;
for i=1:file_count,
    fprintf('Reading %s\n', files{i});
    file_path = [path '/' files{i}];
    if exist(file_path, 'file')
        data = load([path '/' files{i}]);
        ind = ind + 1;
        transitions(ind, [1 2]) = {data.tr_mat files{i}};
    end
end
transitions = transitions(1:ind, :);
end
