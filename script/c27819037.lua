--圣光追逐者
function c27819037.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819037,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,27819037)
	e1:SetCondition(c27819037.spcon)
	e1:SetTarget(c27819037.sptg)
	e1:SetOperation(c27819037.spop)
	c:RegisterEffect(e1) 
	--lv 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17819037) 
	e2:SetTarget(c27819037.lvtg)
	e2:SetOperation(c27819037.lvop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c27819037.immcon)
	e3:SetOperation(c27819037.immop)
	c:RegisterEffect(e3)
end
c27819037.SetCard_XXLight=true   
function c27819037.cfilter(c)
	return c:IsFaceup() and c.SetCard_XXLight 
end
function c27819037.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27819037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c27819037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_VALUE_SELF,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27819037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c27819037.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(2)  
end
function c27819037.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingTarget(c27819037.filter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,c27819037.filter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c27819037.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:IsLevel(1) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(-1)
	tc:RegisterEffect(e2) 
end
function c27819037.immcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_SYNCHRO and rc.SetCard_XXLight and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function c27819037.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819037,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end



