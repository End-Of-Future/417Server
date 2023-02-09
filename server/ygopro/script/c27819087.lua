--五王-力量圣魂
function c27819087.initial_effect(c)
	--change 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,27819087) 
	e1:SetTarget(c27819087.cgtg) 
	e1:SetOperation(c27819087.cgop) 
	c:RegisterEffect(e1) 
end 
c27819087.SetCard_fiveking=true
function c27819087.cgfil(c) 
	return c:IsFaceup() and c:IsLevelAbove(1)   
end 
function c27819087.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c27819087.cgfil,tp,LOCATION_MZONE,0,1,nil) end  
	local lv=Duel.AnnounceLevel(tp,1,8) 
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL) 
	e:SetLabel(lv,att)
	local g=Duel.SelectTarget(tp,c27819087.cgfil,tp,LOCATION_MZONE,0,1,2,nil)
end 
function c27819087.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local lv,att=e:GetLabel() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27819087.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c27819087.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ) 
end









