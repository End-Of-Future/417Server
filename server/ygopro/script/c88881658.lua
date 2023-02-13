--雾都小队 情报搜集官
function c88881658.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88881658.spcon) 
	e1:SetCountLimit(1,88881658+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--to deck  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,18881658) 
	e2:SetCondition(c88881658.tdcon)
	e2:SetTarget(c88881658.tdtg) 
	e2:SetOperation(c88881658.tdop) 
	c:RegisterEffect(e2)
end
function c88881658.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x888)  
end
function c88881658.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		not Duel.IsExistingMatchingCard(c88881658.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88881658.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_LINK) 
end 
function c88881658.tdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x888) 
end 
function c88881658.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88881658.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c88881658.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88881658.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)  
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then  
			Duel.ConfirmCards(1-tp,sg)  
			Duel.BreakEffect() 
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	end 
end 




 

	 
