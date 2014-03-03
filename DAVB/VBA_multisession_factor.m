function [posterior, out] = VBA_multisession_factor(posterior,out)

%% skip if no multisession
if ~(isfield(out.options,'multisession') && isfield(out.options.multisession,'expanded') && out.options.multisession.expanded)
    posteriors = posterior;
    return;
end

%% extract session_wise posteriors
Ts = [0 cumsum(out.options.multisession.split)];

for i=1:numel(out.options.multisession.split)

    idx_X0 = out.options.inF.multisession.indices.X0(:,i);
    idx_theta = out.options.inF.multisession.indices.theta(:,i);
    idx_phi = out.options.inF.multisession.indices.phi(:,i);
       
    posteriors(i).muX0 = posterior.muX0(idx_X0);
    posteriors(i).SigmaX0 = posterior.SigmaX0(idx_X0,idx_X0);
    
    posteriors(i).muTheta = posterior.muTheta(idx_theta);
    posteriors(i).SigmaTheta = posterior.SigmaTheta(idx_theta,idx_theta);
    
    posteriors(i).muPhi = posterior.muPhi(idx_phi);
    posteriors(i).SigmaPhi = posterior.SigmaPhi(idx_phi,idx_phi);

    posteriors(i).a_sigma =  posterior.a_sigma ;
    posteriors(i).b_sigma =  posterior.b_sigma ;
    posteriors(i).a_alpha =  posterior.a_alpha ;
    posteriors(i).b_alpha =  posterior.b_alpha ;
    
    
    idx_t = (Ts(i)+1):Ts(i+1);

    posteriors(i).iQy = posterior.iQy{idx_t,:};
    
   
    posteriors(i).iQx =  cellfun(@(Q) Q(idx_X0,idx_X0),posterior.iQx(idx_t,:)); 
    posteriors(i).muX = posterior.muX(idx_X0,idx_t);
    posteriors(i).SigmaX.current =  cellfun(@(Q) Q(idx_X0,idx_X0),posterior.SigmaX.current(idx_t,:)); 
    posteriors(i).SigmaX.inter =  cellfun(@(Q) Q(idx_X0,idx_X0),posterior.SigmaX.inter(:,idx_t)); 

end
 
posterior.perSession = posteriors;
    
    


end