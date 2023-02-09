--圣光黄金剑圣
function c27822032.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,27822032) 
	e1:SetTarget(c27822032.destg) 
	e1:SetOperation(c27822032.desop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,17822032) 
	e2:SetCondition(c27822032.spcon) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27822032.sptg) 
	e2:SetOperation(c27822032.spop) 
	c:RegisterEffect(e2) 
end 
c27822032.SetCard_XXLight=true 
function c27822032.desfil(c,tp) 
	return c:IsFaceup() and c.SetCard_XXLight and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) 
end 
function c27822032.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c27822032.desfil,tp,LOCATION_ONFIELD,0,1,nil,tp) end 
	local g=Duel.SelectTarget(tp,c27822032.desfil,tp,LOCATION_ONFIELD,0,1,1,nil,tp) 
	local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g)
	g:Merge(g2) 
	Duel.SetTargetCard(g) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c27822032.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()>0 then 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 
function c27822032.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) and e:GetHandler():IsLocation(LOCATION_GRAVE)   
end
function c27822032.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsLevelBelow(9) and c:IsType(TYPE_SYNCHRO) and c.SetCard_XXLight	
end 
function c27822032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c27822032.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c27822032.spfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end 
function c27822032.ckfil(c) 
	return c:IsFaceup() and c.SetCard_XXLight and c:IsType(TYPE_SYNCHRO)	  
end 
function c27822032.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsType(TYPE_TUNER) and c.SetCard_XXLight	
end 
function c27822032.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)	
		if Duel.IsExistingMatchingCard(c27822032.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c27822032.xspfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(27822032,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c27822032.xspfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
		end 
	end  
end 












