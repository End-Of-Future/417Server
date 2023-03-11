--超高校级•钢琴家
function c88882113.initial_effect(c)
	c:SetSPSummonOnce(88882113)
	--link summon
	aux.AddLinkProcedure(c,c88882113.matfilter,1,1)
	c:EnableReviveLimit() 
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c88882113.thtg)
	e1:SetOperation(c88882113.thop)
	c:RegisterEffect(e1)  
	--can not be battle target
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(c88882113.tgtg)
	e2:SetValue(aux.imval1) 
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882113.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3)  
end
c88882113.ACGXJre=true 
function c88882113.matfilter(c) 
	return c.ACGXJre 
end 
function c88882113.thfil(c)
	return c:IsAbleToHand()   
end
function c88882113.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c88882113.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c88882113.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88882113.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 
function c88882113.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0 
end
















