--雾都小队 复合弓械手
function c88881650.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88881650.spcon) 
	e1:SetCountLimit(1,88881650+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,18881650) 
	e2:SetCondition(c88881650.thcon)
	e2:SetTarget(c88881650.thtg) 
	e2:SetOperation(c88881650.thop) 
	c:RegisterEffect(e2)
end
function c88881650.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x888)  
end
function c88881650.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		not Duel.IsExistingMatchingCard(c88881650.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88881650.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_LINK) 
end 
function c88881650.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x888) and c:IsType(TYPE_MONSTER) and not c:IsCode(88881650)  
end 
function c88881650.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88881650.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c88881650.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88881650.thfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end 








