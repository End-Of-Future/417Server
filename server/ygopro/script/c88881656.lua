--雾都小队 剑装改造人
function c88881656.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88881656.spcon) 
	e1:SetCountLimit(1,88881656+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--des and to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,18881656) 
	e2:SetCondition(c88881656.descon)
	e2:SetTarget(c88881656.destg) 
	e2:SetOperation(c88881656.desop) 
	c:RegisterEffect(e2)
end
function c88881656.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x888)  
end
function c88881656.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		not Duel.IsExistingMatchingCard(c88881656.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88881656.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_LINK) 
end 
function c88881656.desfil(c) 
	return c:IsFacedown() or not c:IsSetCard(0x888) 
end 
function c88881656.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88881656.desfil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c88881656.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x889) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end 
function c88881656.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88881656.desfil,tp,LOCATION_MZONE,0,nil)  
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c88881656.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(88881656,0)) then 
			local sg=Duel.SelectMatchingCard(tp,c88881656.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
			Duel.SendtoHand(sg,nil,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end  
	end 
end 









