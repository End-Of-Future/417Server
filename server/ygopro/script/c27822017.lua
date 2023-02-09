--巨大激流灵
function c27822017.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,2) 
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c27822017.lvtg)
	e1:SetValue(c27822017.lvval)
	c:RegisterEffect(e1)	
	--double 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_SET_BASE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(function(e)  
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_LINK) end) 
	e2:SetValue(function(e) 
	return e:GetHandler():GetBaseAttack()*2 end) 
	c:RegisterEffect(e2) 
	--up 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,27822017)
	e3:SetCost(c27822017.upcost) 
	e3:SetTarget(c27822017.uptg) 
	e3:SetOperation(c27822017.upop) 
	c:RegisterEffect(e3) 
end 
c27822017.XXSplash=true 
function c27822017.lvtg(e,c)
	return c:IsLinkAbove(2) 
end
function c27822017.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4
	else return lv end
end 
function c27822017.upcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsAbleToGrave,nil) 
	local tc=og:Select(tp,1,1,nil):GetFirst() 
	Duel.SendtoGrave(tc,REASON_COST) 
	if tc.XXSplash then 
	e:SetLabel(1)
	else e:SetLabel(0) end 
end 
function c27822017.uptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
end 
function c27822017.upop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c27822017.aclimit)
	e1:SetCondition(c27822017.actcon) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1)	
	   if e:GetLabel(1) then 
	   local e2=Effect.CreateEffect(c) 
	   e2:SetType(EFFECT_TYPE_SINGLE) 
	   e2:SetCode(EFFECT_SET_ATTACK_FINAL) 
	   e2:SetRange(LOCATION_MZONE) 
	   e2:SetValue(c:GetAttack()*2) 
	   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	   c:RegisterEffect(e2)  
	   end 
	end 
end 
function c27822017.aclimit(e,re,tp)
	return true 
end
function c27822017.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end



