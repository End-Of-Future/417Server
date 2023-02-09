--激流之界士
function c27822012.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,2) 
	--limit 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetCondition(c27822012.limcon)  
	e1:SetOperation(c27822012.limop) 
	c:RegisterEffect(e1) 
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27822012)
	e1:SetCondition(c27822012.lkcon)
	e1:SetTarget(c27822012.lktg)
	e1:SetOperation(c27822012.lkop)
	c:RegisterEffect(e1)
end
c27822012.XXSplash=true 
function c27822012.limcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_LINK)	
end  
function c27822012.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c27822012.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
function c27822012.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler().XXSplash and re:IsActiveType(TYPE_MONSTER) then 
	Duel.Hint(HINT_CARD,0,27822012)
		Duel.SetChainLimit(c27822012.chainlm)
	end
end
function c27822012.chainlm(e,rp,tp)
	return tp==rp
end
function c27822012.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c27822012.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27822012.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end








