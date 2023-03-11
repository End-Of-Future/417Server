--超高校级•江之岛盾子
function c88882106.initial_effect(c) 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,88882106)
	e1:SetCondition(c88882106.spcon)
	e1:SetTarget(c88882106.sptg)
	e1:SetOperation(c88882106.spop)
	c:RegisterEffect(e1)   
	--link effect 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88882106,1))
	e2:SetCategory(CATEGORY_DISABLE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,18882104)
	e2:SetCondition(c88882106.lkcon)
	e2:SetTarget(c88882106.lktg)
	e2:SetOperation(c88882106.lkop) 
	c:RegisterEffect(e2)   
end 
c88882106.ACGXJre=true  
function c88882106.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c88882106.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88882106.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88882106.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88882106.splimit(e,c) 
	return not c.ACGXJre and not c:IsLocation(LOCATION_EXTRA)
end 
function c88882106.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard().ACGXJre
end
function c88882106.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c88882106.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(e:GetHandler()) 
	e1:SetDescription(aux.Stringid(88882106,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
	e1:SetValue(c88882106.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	end 
end 
function c88882106.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end




