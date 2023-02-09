--风都侦探W-黄金极限疾风王牌
function c10105725.initial_effect(c)  
	c:SetSPSummonOnce(10105725) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,4) 
	c:EnableReviveLimit() 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c10105725.espcon) 
	e1:SetTarget(c10105725.esptg) 
	e1:SetOperation(c10105725.espop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e2)
	--extra att
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(2)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105725,1)) 
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c10105725.atktg)
	e4:SetOperation(c10105725.atkop)
	c:RegisterEffect(e4)
	--negate activate
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(10105725,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c10105725.negcon)
	e5:SetCost(c10105725.negcost)
	e5:SetTarget(c10105725.negtg)
	e5:SetOperation(c10105725.negop)
	c:RegisterEffect(e5) 
	--pay 
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(10105725,3))
	e6:SetType(EFFECT_TYPE_QUICK_O) 
	e6:SetCode(EVENT_FREE_CHAIN) 
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET) 
	e6:SetRange(LOCATION_MZONE) 
	e6:SetCountLimit(1) 
	e6:SetCost(c10105725.pycost) 
	e6:SetTarget(c10105725.pytg) 
	e6:SetOperation(c10105725.pyop)  
	c:RegisterEffect(e6)
end 
function c10105725.ckfil(c,tp) 
	return c:IsCode(10105724) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) 
end 
function c10105725.fckfil(c) 
	return c:IsFaceup() and c:IsCode(10105720)   
end 
function c10105725.espcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105725.ckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c10105725.fckfil,tp,LOCATION_FZONE,0,1,nil)
end 
function c10105725.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c10105725.espop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=eg:Filter(c10105725.ckfil,nil,tp) 
	local fg=Duel.GetMatchingGroup(c10105725.fckfil,tp,LOCATION_FZONE,0,nil)
	g:Merge(fg)
	if c:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0  and g:GetCount()>0 then 
	Duel.Overlay(c,g) 
	end 
end 
function c10105725.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10105725.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c10105725.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c10105725.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10105725.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
end
function c10105725.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.NegateActivation(ev)  
end
function c10105725.pycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)-1) end 
	e:SetLabel(Duel.GetLP(tp)-1) 
	Duel.PayLPCost(tp,Duel.GetLP(tp)-1) 
end  
function c10105725.pytg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c10105725.pyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c10105725.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(e:GetLabel()/2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	end 
end 
function c10105725.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end









