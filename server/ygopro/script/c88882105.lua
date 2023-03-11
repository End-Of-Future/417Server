--超高校级•首领
function c88882105.initial_effect(c) 
	c:SetSPSummonOnce(88882105)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c88882105.lcheck)
	c:EnableReviveLimit() 
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetTarget(c88882105.thtg) 
	e1:SetOperation(c88882105.thop) 
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c88882105.tgtg) 
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882105.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3) 
end 
c88882105.ACGXJre=true  
function c88882105.lcckfil(c) 
	return c.ACGXJre   
end 
function c88882105.lcheck(g)
	return g:IsExists(c88882105.lcckfil,1,nil)
end 
function c88882105.thfil(c) 
	return c:IsAbleToHand() and c.ACGXJre and c:IsType(TYPE_MONSTER)   
end 
function c88882105.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c88882105.thfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c88882105.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c88882105.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 
function c88882105.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end











